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
    
    func loadMessages(_ chatThread: ChatThreadModel) {
        loadMessageObserver = dataManager.loadMessages(chatThread)
            .sink(receiveCompletion: { completion in
                // Handle completion
            }, receiveValue: { chatMessageModels in
                self.messages = chatMessageModels
        })
    }
    
    func sendMessage(chatThread: ChatThreadModel, sender: Contact, message: String) {
        let threadId = "thread_2qHdTgx7WjKuuer7CuzWCBM7"
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
                // Handle completion
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
                        
                        self.queryNextMessagesObserver = ChatGPTHTTPClient.shared.queryNextMessages(chatgptThreadId: threadId, messageId: chatGPTMessagesPostResponse.id)
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
                                
                                self._removeAllPlaceholderMessages()
                                for m in messages {
                                    if m.role == "assistant" {
                                        if (m.content.count > 0) {
                                            let chatMessage = ChatMessageModel(sentTimestamp: Date().timeIntervalSince1970, sender: MockDataHelper.airGPTContact, message: m.content.first!.text.value, chatThread: chatThread)
                                            self.messages.append(chatMessage)
                                        }
                                    }
                                }
                            })
                    })

            })
    }
    
    private func _removeAllPlaceholderMessages() {
        messages.removeAll { message in
            message.type == .placeholder
        }
    }
}
