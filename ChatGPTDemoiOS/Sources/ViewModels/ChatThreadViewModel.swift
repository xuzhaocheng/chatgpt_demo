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
                        let trainingMessage = ChatGPTHTTPClient.shared.trainingMessage(chatThread: self.chatThread, chatgptThreadId: self.chatThread.chatgptThreadId!)
                        self.sendMessage(shouldAddToMessageList: false, chatThread: chatThread, sender: MockDataHelper.selfContact, message: trainingMessage)
                        promixe(.success(self.chatThread))
                    case .failure(let error):
                        promixe(.failure(error))
                    }
                }
                return
            }
            
            self._loadNextMessages(messageId: nil, includeRoles: ["assistant", "user"])
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
                ChatThreadDataManager.shared.addCachedChatGPTThreadId(listingId: self.chatThread.listing!.id, chatGPTThreadId: chatGPTThreadCreateResponse.id)
                completion(.success(self.chatThread))
            })
    }
    
    private func _loadMessages(_ chatThread: ChatThreadModel) {
        _loadNextMessages(messageId: nil, includeRoles: ["assistant", "user"])
//        loadMessageObserver = dataManager.loadThread(chatThread)
//            .sink(receiveCompletion: { completion in
//                // Handle completion
//            }, receiveValue: { chatMessageModels in
//                self.messages = chatMessageModels
//        })
    }
    
    func sendMessage(shouldAddToMessageList: Bool = true, chatThread: ChatThreadModel, sender: Contact, message: String) {
        guard let threadId = self.chatThread.chatgptThreadId else {
            return
        }
        
        let newMessage = ChatMessageModel(sentTimestamp: Date().timeIntervalSince1970, sender: sender, message: message, chatThread: self.chatThread)
        
        if shouldAddToMessageList {
            self.messages.append(newMessage)
        }
        
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
                        self._loadNextMessages(messageId: chatGPTMessagesPostResponse.id)
                    })

            })
    }
    
    private func _loadNextMessages(messageId: String?, includeRoles: [String] = ["assistant"]) {
        self.queryNextMessagesObserver = ChatGPTHTTPClient.shared.queryNextMessages(chatgptThreadId: self.chatThread.chatgptThreadId!, messageId: messageId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Getting messages complete")
                case .failure(let error):
                    print("Getting messages failed: \(error)")
                }
            }, receiveValue: { chatGPTMessageListResponse in
                self._loadChatGPTMessages(chatGPTMessageListResponse, includeRoles: includeRoles)
            })
    }
    
    private func _loadChatGPTMessages(_ chatGPTMessageListResponse: ChatGPTMessageListResponse, includeRoles: [String]) {
        guard let messages = chatGPTMessageListResponse.data else {
            return
        }
        
        self._removeAllPlaceholderMessages()
        
        for (index, m) in messages.enumerated() {
            guard includeRoles.contains(m.role),
                  m.content.count > 0 else {
                continue
            }
            
            if index == 0 && m.role == "user" && m.id == chatGPTMessageListResponse.first_id {
                continue // HACK for demo purposes to not show the first user message, since this first message is the training prompt
            }
            
            let contact = m.role == "user" ? MockDataHelper.selfContact : MockDataHelper.airGPTContact
            
            let chatMessage = ChatMessageModel(sentTimestamp: Date().timeIntervalSince1970, sender: contact, message: m.content.first!.text.value, chatThread: chatThread)
            self.messages.append(chatMessage)
        }
    }
    
    private func _removeAllPlaceholderMessages() {
        messages.removeAll { message in
            message.type == .placeholder
        }
    }
}
