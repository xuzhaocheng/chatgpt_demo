//
//  ChatThreadDataManager.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/23/24.
//

import Foundation

class ChatThreadDataManager: NSObject, ObservableObject {
    static let shared = ChatThreadDataManager()
    
    @Published private(set) var messages: [ChatMessageModel] = []

}
