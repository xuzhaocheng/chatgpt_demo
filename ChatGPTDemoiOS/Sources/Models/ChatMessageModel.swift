//
//  ChatMessageModel.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/25/24.
//

import Foundation

struct ChatMessageModel {
    let id: String
    let sender: Contact
    let message: String
    let chatThread: ChatThreadModel

    init(id: String = UUID().uuidString, sender: Contact, message: String, chatThread: ChatThreadModel) {
        self.id = id
        self.sender = sender
        self.message = message
        self.chatThread = chatThread
    }
}
