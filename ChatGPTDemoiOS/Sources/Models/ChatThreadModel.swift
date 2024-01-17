//
//  ChatThreadModel.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/17/24.
//

import Foundation

struct ChatThreadModel: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let snippet: String
    let status: String?
    let isRead: Bool
    
    init(id: String = UUID().uuidString, title: String, snippet: String, status: String?, isRead: Bool) {
        self.id = id
        self.title = title
        self.snippet = snippet
        self.status = status
        self.isRead = isRead
    }
}
