//
//  OllamaChatCompletionResponse.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/28/24.
//

import Foundation

struct OllamaChatCompletionResponse: Codable {
    let created_at: String?
    let message: OllamaChatCompletionMessageResponse
}

struct OllamaChatCompletionMessageResponse: Codable {
    let role: String
    let content: String
}


