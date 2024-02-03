//
//  ChatMessageModel.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/25/24.
//

import Foundation

enum ChatMessageType {
    case normal
    case placeholder
}

struct ChatMessageModel: Identifiable, Hashable {
    let type: ChatMessageType
    let id: String
    let sentTimestamp: Double
    let sender: Contact
    let message: String
    let chatThread: ChatThreadModel

    init(id: String = UUID().uuidString, type: ChatMessageType = .normal, sentTimestamp: Double, sender: Contact, message: String, chatThread: ChatThreadModel) {
        self.id = id
        self.type = type
        self.sentTimestamp = sentTimestamp
        self.sender = sender
        self.message = message
        self.chatThread = chatThread
    }
}
