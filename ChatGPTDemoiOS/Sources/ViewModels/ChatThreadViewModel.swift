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
    private var loadMessageObserver: AnyCancellable?
    private var sendMessageObserver: AnyCancellable?
    private var pollRunObserver: AnyCancellable?
    
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
        let newMessage = ChatMessageModel(sender: sender, message: message, chatThread: self.chatThread)
        self.messages.append(newMessage)
        
        sendMessageObserver = ChatGPTHTTPClient.shared.sendMessage(chatThread: chatThread, chatgptThreadId: "thread_2qHdTgx7WjKuuer7CuzWCBM7", prompt: message)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Send Message Complete")
                case .failure(let error):
                    print("Send Message Failed \(error)")
                }
                // Handle completion
            }, receiveValue: { chatGPTAssistantRunResponse in
                if chatGPTAssistantRunResponse.status != "completed" {
                    let chatMessage = ChatMessageModel(sender: PreviewHelper.airGPTContact, message: "Please wait, processing....", chatThread: chatThread)
                    self.messages.append(chatMessage)
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
                        
                        let chatMessage = ChatMessageModel(sender: PreviewHelper.airGPTContact, message: "Polling run completed with status: \(chatGPTAssistantRunResponse.status)", chatThread: chatThread)
                        self.messages.append(chatMessage)
                    })

            })
    }
}
