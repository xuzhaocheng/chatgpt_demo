//
//  ChatThreadViewModel.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/17/24.
//

import Foundation
import Combine

class ChatThreadViewModel: ObservableObject {
    
    private var dataManager: ChatThreadDataManager
    private var chatThread: ChatThreadModel
    private var lastUserMessgeSentId: String?
    
    private var createChatGPTThreadObserver: AnyCancellable?
    private var trainingMessageObserver: AnyCancellable?
    private var loadMessageObserver: AnyCancellable?
    private var sendMessageObserver: AnyCancellable?
    private var pollRunObserver: AnyCancellable?
    private var queryNextMessagesObserver: AnyCancellable?

    @Published private(set) var messages: [ChatMessageModel] = []
    
    init(dataManager: ChatThreadDataManager, chatThread: ChatThreadModel) {
        self.dataManager = dataManager
        self.chatThread = chatThread
    }
    
    @Published var chatThreads: [ChatThreadModel] = []
    
    func loadThread(_ chatThread: ChatThreadModel) -> Future<ChatThreadModel, Error> {
        Future<ChatThreadModel, Error> { promixe in
            self.chatThread = chatThread
            
            guard self.chatThread.chatgptThreadId != nil,
                  self.chatThread.chatgptThreadId! != "" else {
                self._createChatGPTThread { result in
                    switch result {
                    case .success(_):
                        // Tell ChatGPT to tell it to be an assistant to current listing
                        self._sendChatGPTTrainingMessage { trainingMessageResult in
                            switch trainingMessageResult {
                            case .success(_):
                                promixe(.success(self.chatThread))
                            case .failure(let trainingMessageError):
                                promixe(.failure(trainingMessageError))
                            }
                        }
                        
                    case .failure(let error):
                        promixe(.failure(error))
                    }
                }
                return
            }
            
            self._loadMessages(self.chatThread)
            promixe(.success(self.chatThread))
        }
    }
    
    private func _createChatGPTThread(_ completion: @escaping (Result<ChatThreadModel, Error>) -> Void) {
        createChatGPTThreadObserver = ChatGPTHTTPClient.shared.createChatGPTThread()
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    print("Create ChatGPTThread Complete")
                case .failure(let error):
                    print("Create ChatGPTThread Failed: \(error)")
                    completion(.failure(error))
                }
            }, receiveValue: { chatGPTThreadCreateResponse in
                self.chatThread = self.chatThread.updateChatGPTThreadId(chatGPTThreadCreateResponse.id)
                completion(.success(self.chatThread))
            })
    }
    
    private func _sendChatGPTTrainingMessage(_ completion: @escaping (Result<ChatThreadModel, Error>) -> Void) {
        trainingMessageObserver = ChatGPTHTTPClient.shared.sendTrainingMessage(chatThread: self.chatThread, chatgptThreadId: self.chatThread.chatgptThreadId!)
            .sink(receiveCompletion: { results in
                switch results {
                case .finished:
                    break
                case .failure(let error):
                    completion(.failure(error))
                }
            }, receiveValue: { chatGPTMessagesPostResponse, chatGPTAssistantRunResponse in
                self._loadNextMessages(chatGPTMessagesPostResponse.id)
            })
    }
    
    private func _loadMessages(_ chatThread: ChatThreadModel) {
        loadMessageObserver = dataManager.loadThread(chatThread)
            .sink(receiveCompletion: { completion in
                // Handle completion
            }, receiveValue: { chatMessageModels in
                self.messages = chatMessageModels
        })
    }
    
    func sendMessage(chatThread: ChatThreadModel, sender: Contact, message: String) {
        guard let threadId = self.chatThread.chatgptThreadId else {
            return
        }
        
        let newMessage = ChatMessageModel(sentTimestamp: Date().timeIntervalSince1970, sender: sender, message: message, chatThread: self.chatThread)
        self.messages.append(newMessage)
        
        sendMessageObserver = ChatGPTHTTPClient.shared.sendMessage(chatThread: chatThread, chatgptThreadId: threadId, prompt: message)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Send Message Complete")
                case .failure(let error):
                    print("Send Message Failed \(error)")
                }
            }, receiveValue: { (chatGPTMessagesPostResponse, chatGPTAssistantRunResponse) in
                print("Successfully sent messsage: \(chatGPTMessagesPostResponse.id)")
                self.lastUserMessgeSentId = chatGPTMessagesPostResponse.id
                
                if chatGPTAssistantRunResponse.status != "completed" {
                    self.messages.append(MockDataHelper.airGPTPlaceholderMessage(chatThread: chatThread))
                }
                
                // Start Polling run
                print("Polling run \(chatGPTAssistantRunResponse.id)")
                self.pollRunObserver = ChatGPTHTTPClient.shared.pollRun(chatgptThreadId: chatGPTAssistantRunResponse.thread_id, runId: chatGPTAssistantRunResponse.id)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            print("Polling run finished")
                        case .failure(let error):
                            print("Polling run failed \(error)")
                        }
                    }, receiveValue: { chatGPTAssistantRunResponse in
                        print("Polling run completed with status: \(chatGPTAssistantRunResponse.status)")
                        self._loadNextMessages(chatGPTMessagesPostResponse.id)
                    })

            })
    }
    
    private func _loadNextMessages(_ messageId: String) {
        self.queryNextMessagesObserver = ChatGPTHTTPClient.shared.queryNextMessages(chatgptThreadId: self.chatThread.chatgptThreadId!, messageId: messageId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Getting messages complete")
                case .failure(let error):
                    print("Getting messages failed: \(error)")
                }
            }, receiveValue: { chatGPTMessageListResponse in
                guard let messages = chatGPTMessageListResponse.data else {
                    return
                }
                
                self._loadChatGPTMessages(messages)
            })
    }
    
    private func _loadChatGPTMessages(_ chatGPTMessages: [ChatGPTMessage]?) {
        guard let messages = chatGPTMessages else {
            return
        }
        
        self._removeAllPlaceholderMessages()
        
        for m in messages {
            if m.role == "assistant" {
                if (m.content.count > 0) {
                    let chatMessage = ChatMessageModel(sentTimestamp: Date().timeIntervalSince1970, sender: MockDataHelper.airGPTContact, message: m.content.first!.text.value, chatThread: chatThread)
                    self.messages.append(chatMessage)
                }
            }
        }
    }
    
    private func _removeAllPlaceholderMessages() {
        messages.removeAll { message in
            message.type == .placeholder
        }
    }
}
