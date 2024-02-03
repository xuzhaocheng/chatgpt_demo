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
    
    private let maxPollRetry: Int = 5
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
    
    func createChatGPTThread() -> Future<ChatGPTThreadCreateResponse, Error> {
        Future<ChatGPTThreadCreateResponse, Error> { promixe in
            
            AF.request(self.baseURL + "/threads", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: self._headers())
                .validate()
                .responseDecodable(of: ChatGPTThreadCreateResponse.self) { response in
                    switch response.result {
                    case .success(let chatGPTThreadCreateResponse):
                        print("Thread Create success: \(chatGPTThreadCreateResponse.id)")
                        promixe(.success(chatGPTThreadCreateResponse))
                    case .failure(let error):
                        print("Thread Create failure: \(String(describing: error))")
                        promixe(.failure(error))
                        
                    }
                }
        }
    }
    
    func trainingMessage(chatThread: ChatThreadModel, chatgptThreadId: String) -> String {
        "You are an AI Chatbot for AirBnB.  You will answer questions on a listing with this description \"\(chatThread.listing!.description)\".  Greet the user with a short and friendly welcome message. The welcome message should not mention about the detailed description the user has provided."
    }

    func sendMessage(chatThread: ChatThreadModel, chatgptThreadId: String, prompt: String) -> Future<(ChatGPTMessagesPostResponse, ChatGPTAssistantRunResponse), Error> {
        Future { promixe in
            let params: [String: Any] = [
                "role": "user",
                "content": prompt
            ]
            
            AF.request(self.baseURL + "/threads/\(chatgptThreadId)/messages", method: .post, parameters: params, encoding: JSONEncoding.default, headers: self._headers())
                .validate()
                .responseDecodable(of: ChatGPTMessagesPostResponse.self) { response in
                    switch response.result {
                        case .success(let chatGPTMessagePostResponse):
                            print("Messsage send success: \(chatGPTMessagePostResponse.id)")
                            self._triggerAssistantRun(chatgptThreadId: chatgptThreadId) { assistantRunResult in
                                switch assistantRunResult {
                                case .success(let chatGPTAssistantRunResponse):
                                    promixe(.success((chatGPTMessagePostResponse, chatGPTAssistantRunResponse)))
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
    
    private func _triggerAssistantRun(chatgptThreadId: String, completion: @escaping (Result<ChatGPTAssistantRunResponse, Error>) -> Void) {
        let params: [String: Any] = [
            "assistant_id": "\(assistantID)",
        ]
        
        AF.request(baseURL + "/threads/\(chatgptThreadId)/runs", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers())
            .validate()
            .responseDecodable(of: ChatGPTAssistantRunResponse.self) { response in
                switch response.result {
                case .success(let chatGPTAssistantRunResponse):
                    print("Run Assistant success: \(chatGPTAssistantRunResponse.id)")
                    completion(.success(chatGPTAssistantRunResponse))
                case .failure(let error):
                    print("Error while running assistant: \(String(describing: error))")
                    completion(.failure(error))
                }
            }
    }
    
    func pollRun(chatgptThreadId: String, runId: String) -> Future<ChatGPTAssistantRunResponse, Error> {
        let retries = 0
        
        return
        Future<ChatGPTAssistantRunResponse, Error> { promixe in
            self._pollRunTry(chatgptThreadId: chatgptThreadId, runId: runId, tryNumber: retries) { result in
                switch result {
                case .success(let chatGPTAssistantRunRespons):
                    promixe(.success(chatGPTAssistantRunRespons))
                case .failure(let error):
                    promixe(.failure(error))
                }
            }
        }
    }
    
    func _pollRunTry(chatgptThreadId: String, runId: String, tryNumber: Int, completion: @escaping (Result<ChatGPTAssistantRunResponse, Error>) -> Void)  {
        guard tryNumber <= maxPollRetry else {   // Stop when we reach max number of polling tries
            completion(.failure(NSError(domain: "com.midoriapple.chatgptdemo", code: 0, userInfo: [NSLocalizedDescriptionKey : "Max number of retries reached"])))
            return
        }
        
        AF.request(self.baseURL + "/threads/\(chatgptThreadId)/runs/\(runId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self._headers())
            .validate()
            .responseDecodable(of: ChatGPTAssistantRunResponse.self) { response in
                switch response.result {
                case .success(let chatGPTResponse):
                    if chatGPTResponse.status == "completed" {
                        completion(.success(chatGPTResponse))
                        return
                    }
                    
                    let waitDuration: Int = NSDecimalNumber(decimal: pow(2, tryNumber)).intValue
                    DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(waitDuration)) {
                        self._pollRunTry(chatgptThreadId: chatgptThreadId, runId: runId, tryNumber: tryNumber+1, completion: completion)
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func queryNextMessages(chatgptThreadId: String, messageId: String?) -> Future<ChatGPTMessageListResponse, Error> {
        Future<ChatGPTMessageListResponse, Error> { promixe in
            
            var url = self.baseURL + "/threads/\(chatgptThreadId)/messages?order=asc"
            if let mId = messageId {
                url += "&after=\(mId)"
            }
            print("URL: \(url)")
            
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self._headers())
                .validate()
                .responseDecodable(of: ChatGPTMessageListResponse.self) { response in
                    switch response.result {
                    case .success(let chatGPTMessageListResponse):
                        promixe(.success(chatGPTMessageListResponse))
                    case .failure(let error):
                        promixe(.failure(error))
                    }
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
}
