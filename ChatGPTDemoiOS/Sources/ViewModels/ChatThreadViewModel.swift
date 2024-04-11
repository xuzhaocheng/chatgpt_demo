//
//  ChatThreadViewModel.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/17/24.
//

import Foundation
import Combine
import OSLog
import Swinject

class ChatThreadViewModel: ObservableObject, ChatThreadViewModelActionsDelegate {
    
    private var chatThreadViewModelActions: ChatThreadViewModelActionsProviding? = nil
    private var chatThread: ChatThreadModel

    @Published var messages: [ChatMessageModel] = []
    
    init(chatThread: ChatThreadModel) {
        self.chatThread = chatThread
        
        self.chatThreadViewModelActions = Container.shared.resolve(ChatThreadViewModelActionsProviding.self, arguments: ChatThreadDataManager.shared.llvmPreference(), chatThread, self as ChatThreadViewModelActionsDelegate)
    }
    
    @Published var chatThreads: [ChatThreadModel] = []
    
    func loadThread() -> Future<ChatThreadModel, Error>? {
        chatThreadViewModelActions?.loadThread()
    }
    
    func sendMessage(shouldAddToMessageList: Bool = true, chatThread: ChatThreadModel, sender: Contact, message: String) {
        chatThreadViewModelActions?.sendMessage(shouldAddToMessageList: shouldAddToMessageList, chatThread: chatThread, sender: sender, message: message)
    }
    
    func removeAllPlaceholderMessages() {
        messages.removeAll { message in
            message.type == .placeholder
        }
    }
    
    func addFailureMessage() {
        removeAllPlaceholderMessages()
        messages.append(MockDataHelper.airGPTMessage(message: "Something went wrong, please try again.", chatThread: self.chatThread))
    }
    
    func appendMessage(message: ChatMessageModel) {
        messages.append(message)
    }
}
