//
//  ContainerExtension.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 4/11/24.
//

import Swinject

extension Container {
    static let shared: Container = {
        let container = Container()
        
        container.register(ChatThreadViewModelActionsProviding.self) { (resolver, llvmType: LLVMType, chatThreadModel: ChatThreadModel, delegate: ChatThreadViewModelActionsDelegate) in

            switch(llvmType) {
            case .chatGPT:
                return ChatThreadChatGPTActions(chatThread: chatThreadModel, delegate: delegate)
            case .ollama:
                return ChatThreadOllamaActions(chatThread: chatThreadModel, delegate: delegate)
            case .lmStudio:
                return ChatThreadLMStudioActions(chatThread: chatThreadModel, delegate: delegate)
            }
        }
        
        return container
    }()
}

