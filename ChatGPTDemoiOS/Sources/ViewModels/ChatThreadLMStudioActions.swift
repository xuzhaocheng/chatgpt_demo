//
//  ChatThreadChatGPTActions.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/28/24.
//

import Combine
import OSLog

class ChatThreadLMStudioActions: ChatThreadViewModelActionsProviding {
    var chatThread: ChatThreadModel

    private var sendMessageObserver: AnyCancellable? = nil
    private weak var delegate: ChatThreadViewModelActionsDelegate?
    
    init(chatThread: ChatThreadModel, delegate: ChatThreadViewModelActionsDelegate) {
        self.chatThread = chatThread
        self.delegate = delegate
    }
    
    func loadThread() -> Future<ChatThreadModel, Error> {
        self.delegate?.appendMessage(message: MockDataHelper.airGPTPlaceholderMessage(chatThread: chatThread))

        return
        Future<ChatThreadModel, Error> { promixe in
            self.sendMessageObserver = LMStudioHTTPClient.shared.sendInitialMessage(chatThread: self.chatThread)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        Logger.system.infoAndCache("Load thread succeeded")
                        promixe(.success(self.chatThread))
                        self.delegate?.removeAllPlaceholderMessages()
                    case .failure(let error):
                        Logger.system.errorAndCache("Load thread Failed \(error)")
                        promixe(.failure(error))
                        self.delegate?.addFailureMessage()
                    }
                }, receiveValue: { lmStudioChatCompletionResponse in
                    if let messageContent = lmStudioChatCompletionResponse.choices?.first?.message.content {
                        self.delegate?.appendMessage(message: MockDataHelper.airGPTMessage(message: messageContent, chatThread: self.chatThread))
                    } else {
                        self.delegate?.addFailureMessage()
                    }
                })
        }
    }
    
    func sendMessage(shouldAddToMessageList: Bool = true, chatThread: ChatThreadModel, sender: Contact, message: String) {
        let newMessage = ChatMessageModel(sentTimestamp: Date().timeIntervalSince1970, sender: sender, message: message, chatThread: self.chatThread)
        
        if shouldAddToMessageList {
            self.delegate?.appendMessage(message: newMessage)
        }
        
        self.delegate?.appendMessage(message: MockDataHelper.airGPTPlaceholderMessage(chatThread: chatThread))
        
        sendMessageObserver = LMStudioHTTPClient.shared.sendMessage(chatThread: chatThread, prompt: message, historicalMessages: self.delegate?.messages)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Logger.system.infoAndCache("Send Message Complete")
                    self.delegate?.removeAllPlaceholderMessages()
                case .failure(let error):
                    Logger.system.errorAndCache("Send Message Failed \(error)")
                    self.delegate?.addFailureMessage()
                }
            }, receiveValue: { lmStudioChatCompletionResponse in
                self.delegate?.appendMessage(message: MockDataHelper.airGPTMessage(message: lmStudioChatCompletionResponse.choices?.first?.message.content ?? "ERROR NO MESSAGE", chatThread: self.chatThread))
            })
    }
}
