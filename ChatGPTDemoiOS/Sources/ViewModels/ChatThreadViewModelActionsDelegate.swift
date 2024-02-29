//
//  ChatThreadViewModelDelegate.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/28/24.
//

import Foundation

protocol ChatThreadViewModelActionsDelegate: AnyObject {
    var messages: [ChatMessageModel] { get set}
    
    func removeAllPlaceholderMessages()
    
    func addFailureMessage()
    
    func appendMessage(message: ChatMessageModel)
    
//    func messages() -> [ChatMessageModel]
}
