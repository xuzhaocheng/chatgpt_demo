//
//  ChatGPTDataManager.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/1/24.
//

import Foundation
import Alamofire
import Combine
import OSLog

class LMStudioHTTPClient {
    static let shared = LMStudioHTTPClient()
    
#if targetEnvironment(simulator)
    let baseURL = "http://localhost:1234/v1"
#else
    let baseURL = "http://192.168.8.153:1234/v1"
#endif
    
    func trainingMessage(chatThread: ChatThreadModel) -> String {
        "You are an AI Chatbot for AirBnB.  You will answer questions on a listing with this description \"\(chatThread.listing!.description)\".  Greet the user with a short and friendly welcome message. The welcome message should not mention about the detailed description the user has provided."
    }
    
    func sendInitialMessage(chatThread: ChatThreadModel) -> Future<LMStudioChatCompletionResponse, Error> {
        sendMessage(chatThread: chatThread, prompt: nil, historicalMessages: nil)
    }

    func sendMessage(chatThread: ChatThreadModel, prompt: String?, historicalMessages: [ChatMessageModel]?) -> Future<LMStudioChatCompletionResponse, Error> {
        Future { promixe in
            var messages: [[String: Any]] = []
            
            messages.append([
                "role": "system",
                "content": self.trainingMessage(chatThread: chatThread)
            ])
            
            messages.append(contentsOf: self._transformHistoricalMessages(historicalMessages))
            
            if let prompt = prompt {
                [
                    "role": "user",
                    "content": prompt
                ]
            }
            
            let params: [String: Any] = [
                "messages": messages,
                "temperature": 0.7,
                "max_tokens": -1,
                "stream": false
            ]
            
            AF.request(self.baseURL + "/chat/completions", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseDecodable(of: LMStudioChatCompletionResponse.self) { response in
                    switch response.result {
                        case .success(let messagePostResponse):
                            Logger.system.infoAndCache("Messsage send success: \(messagePostResponse.id)")
                        promixe(.success(messagePostResponse))
                        case .failure(let error):
                            Logger.system.errorAndCache("Error while adding message: \(String(describing: error))")
                            promixe(.failure(error))
                        }
                    }
            }
    }
    
    private func _transformHistoricalMessages(_ historicalMessages: [ChatMessageModel]?) -> [[String: Any]] {
        guard let historicalMessages = historicalMessages else {
            return []
        }
        
        var result: [[String: Any]] = []
        
        for chatMessageModel in historicalMessages {
            if chatMessageModel.type == .normal {
                result.append([
                    "role": (chatMessageModel.sender.isSelf ? "user" : "assistant"),
                    "content": chatMessageModel.message
                ])
            }
        }
        
        return result
    }
}
