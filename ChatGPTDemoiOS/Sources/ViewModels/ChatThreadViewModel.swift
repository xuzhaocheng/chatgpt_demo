//
//  ChatThreadViewModel.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/17/24.
//

import Foundation
import Combine
import OSLog

class ChatThreadViewModel: ObservableObject, ChatThreadViewModelActionsDelegate {
    
    private var chatThreadViewModelActions: ChatThreadViewModelActions? = nil
    private var chatThread: ChatThreadModel

    @Published var messages: [ChatMessageModel] = []
    
    init(chatThread: ChatThreadModel) {
        self.chatThread = chatThread
        
        switch ChatThreadDataManager.shared.llvmPreference() {
        case .chatGPT:
            self.chatThreadViewModelActions = ChatThreadChatGPTActions(chatThread: chatThread, delegate: self)
        case .ollama:
            self.chatThreadViewModelActions = ChatThreadOllamaActions(chatThread: chatThread, delegate: self)
        case .lmStudio:
            self.chatThreadViewModelActions = ChatThreadLMStudioActions(chatThread: chatThread, delegate: self)
        }

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
