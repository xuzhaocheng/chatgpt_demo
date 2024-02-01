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
    private var observer: AnyCancellable?
    
    @Published private(set) var messages: [ChatMessageModel] = []
    
    init(dataManager: ChatThreadDataManager, chatThread: ChatThreadModel) {
        self.dataManager = dataManager
        self.chatThread = chatThread
    }
    
    @Published var chatThreads: [ChatThreadModel] = []
    
    func loadMessages(_ chatThread: ChatThreadModel) {
        observer = dataManager.loadMessages(chatThread).sink(receiveCompletion: { completion in
            
        }, receiveValue: { chatMessageModels in
            self.messages = chatMessageModels
        })
    }
    
    func sendMessage(sender: Contact, message: String) {
        let newMessage = ChatMessageModel(sender: sender, message: message, chatThread: self.chatThread)
        self.messages.append(newMessage)
    }
}
