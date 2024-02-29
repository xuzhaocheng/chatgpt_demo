//
//  ChatThreadViewModelDelegate.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/28/24.
//

import Foundation

protocol ChatThreadViewModelActionsDelegate: AnyObject {
    func removeAllPlaceholderMessages()
    
    func addFailureMessage()
    
    func appendMessage(message: ChatMessageModel)
}
