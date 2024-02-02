//
//  ChatGPTResponseHelper.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/2/24.
//

import Foundation

struct ChatGPTMessagesPostResponse: Codable {
    let id: String
    let thread_id: String
    let role: String
    let content: [ResponseContent]
    
    struct ResponseContent: Codable {
        let type: String
        let text: ResponseText
    }
    
    struct ResponseText: Codable {
        let value: String
        let annotations: [String]
    }
}

struct ChatGPTAssistantRunResponse: Codable {
    let id: String
    let assistant_id: String
    let thread_id: String
    let status: String
    let started_at: Int?
    let expires_at: Int?
    let cancelled_at: Int?
    let failed_at: Int?
    let completed_at: Int?
    let last_error: String?
    let model: String
    let instructions: String
    let file_ids: [String]?
}

struct ChatGPTResponseHelper {
    static let shared = ChatGPTResponseHelper()
    
    
}
