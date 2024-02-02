//
//  ChatGPTDataManager.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/1/24.
//

import Foundation
import Alamofire
import Combine

class ChatGPTHTTPClient {
    static let shared = ChatGPTHTTPClient()
    
    let baseURL = "https://api.openai.com/v1"
    
    private let openAIAPIKey: String
    private let assistantID: String
    
    init() {
        var apiKey: String = ""
        var aID: String = ""
        
        if let infoDictionary: [String: Any] = Bundle.main.infoDictionary {
            if let v: String = infoDictionary["OpenAIAPIKey"] as? String,
               v != "" {
                apiKey = v
            } else {
                fatalError("Error Getting OpenAIAPIKey from Info.plist")
            }
            
            if let v: String = infoDictionary["OpenAIAssistantId"] as? String,
               v != "" {
                aID = v
            } else {
                fatalError("Error Getting OpenAIAssistantId from Info.plistD")
            }
        } else {
            fatalError("Error Reading Info.plist")
        }
        
        self.openAIAPIKey = apiKey
        self.assistantID = aID
    }

    func sendMessage(chatThread: ChatThreadModel, chatgptThreadId: String, prompt: String) -> Future<[ChatMessageModel], Error> {
        return Future { promixe in
            let params: [String: Any] = [
                "role": "user",
                "content": prompt
            ]
            
            AF.request(self.baseURL + "/threads/\(chatgptThreadId)/messages", method: .post, parameters: params, encoding: JSONEncoding.default, headers: self._headers())
                .validate()
                .responseDecodable(of: ChatGPTMessagesPostResponse.self) { response in
                    switch response.result {
                        case .success(let chatGPTResponse):
                            print("Messsage success: \(chatGPTResponse.id)")
                            self._triggerAssistantRun(chatgptThreadId: chatgptThreadId) { assistantRunResult in
                                switch assistantRunResult {
                                case .success:
                                    promixe(.success([
                                        ChatMessageModel(sender: PreviewHelper.airGPTContact, message: "Please wait, processing....", chatThread: chatThread)
                                    ]))
                                case .failure(let error):
                                    promixe(.failure(error))
                                }
                            }
                        case .failure(let error):
                            print("Error while adding message: \(String(describing: error))")
                            promixe(.failure(error))
                        }
                    }
            }
    }
    
    private func _triggerAssistantRun(chatgptThreadId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let params: [String: Any] = [
            "assistant_id": "\(assistantID)",
        ]
        
        AF.request(baseURL + "/threads/\(chatgptThreadId)/runs", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers())
            .validate()
            .responseDecodable(of: ChatGPTAssistantRunPostResponse.self) { response in
                switch response.result {
                case .success(let chatGPTResponse):
                    print("Run Assistant success: \(chatGPTResponse.id)")
                    completion(.success(chatGPTResponse.id)) // Return run_id
                case .failure(let error):
                    print("Error while running assistant: \(String(describing: error))")
                    completion(.failure(error))
                }
            }
    }
    
    private func _headers() -> HTTPHeaders {
        [
           "Content-Type": "application/json",
           "Authorization": "Bearer \(self.openAIAPIKey)",
           "OpenAI-Beta": "assistants=v1"
       ]
    }
    
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
    
    struct ChatGPTAssistantRunPostResponse: Codable {
        let id: String
        let assistant_id: String
        let thread_id: String
        let status: String
        let expires_at: Int?
        let cancelled_at: Int?
        let failed_at: Int?
        let completed_at: Int?
        let last_error: String?
        let model: String
        let instructions: String
        let file_ids: [String]?
    }
}
