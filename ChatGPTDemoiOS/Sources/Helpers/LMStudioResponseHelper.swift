//
//  LMStudioResponseHelper.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/28/24.
//

import Foundation

struct LMStudioChatCompletionResponse: Codable {
    let id: String
    let object: String
    let created: Int?
    let choices: [LMStudioChatCompletionChoiceResponse]?
}

struct LMStudioChatCompletionChoiceResponse: Codable {
    let index: Int
    let message: LMStudioChatCompletionChoiceMessageResponse
    let finish_reason: String
}

struct LMStudioChatCompletionChoiceMessageResponse: Codable {
    let role: String
    let content: String
}


