//
//  ChatThreadViewModelActions.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/28/24.
//

import Foundation

import Combine

protocol ChatThreadViewModelActionsProviding {  
    var chatThread: ChatThreadModel { get set }

    func loadThread() -> Future<ChatThreadModel, Error>
    
    func sendMessage(shouldAddToMessageList: Bool, chatThread: ChatThreadModel, sender: Contact, message: String)
}
