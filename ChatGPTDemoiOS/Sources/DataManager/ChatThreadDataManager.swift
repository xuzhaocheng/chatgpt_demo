//
//  ChatThreadDataManager.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/23/24.
//

import Foundation
import Combine

enum LLVMType: Int {
    case chatGPT = 0
    case lmStudio = 1
}

class ChatThreadDataManager: NSObject, ObservableObject {
    static let shared = ChatThreadDataManager(chatGPTDataManager: ChatGPTHTTPClient.shared)
    private let cachedChatGPTUserDefaultsKey = "cachedChatGPTUserDefaultsKey"
    private let llvmPreferenceUserDefaultsKey = "llvmPreferenceUserDefaultsKey"

    var chatGPTDataManager: ChatGPTHTTPClient
    
    init(chatGPTDataManager: ChatGPTHTTPClient) {
        self.chatGPTDataManager = chatGPTDataManager
    }
    
    func loadThread(_ chatThread: ChatThreadModel) -> Future<[ChatMessageModel], Error> {
        return Future { promixe in
            promixe(.success(MockDataHelper.initialWelcomeMessages(chatThreadModel: chatThread)))
        }
    }
    
    func addCachedChatGPTThreadId(listingId: String, chatGPTThreadId: String) {
        guard var cache = UserDefaults.standard.dictionary(forKey: cachedChatGPTUserDefaultsKey) else {
            let newCache: [String: String] = [
                listingId:chatGPTThreadId
            ]
            UserDefaults.standard.set(newCache, forKey: cachedChatGPTUserDefaultsKey)
            return
        }
        
        cache[listingId] = chatGPTThreadId
        UserDefaults.standard.set(cache, forKey: cachedChatGPTUserDefaultsKey)
    }
    
    func cachedChatGPTThreadId(listingId: String) -> String? {
        guard let cache = UserDefaults.standard.dictionary(forKey: cachedChatGPTUserDefaultsKey) else {
            return nil
        }
        
        return cache[listingId] as? String
    }
    
    func clearChatGPTThreads() {
        UserDefaults.standard.removeObject(forKey: cachedChatGPTUserDefaultsKey)
    }
    
    func llvmPreference() -> LLVMType {
        LLVMType(rawValue: UserDefaults.standard.integer(forKey: llvmPreferenceUserDefaultsKey))!
    }
    
    func setLlvmPreference(llvmPreference: LLVMType) {
        UserDefaults.standard.set(llvmPreference.rawValue, forKey: llvmPreferenceUserDefaultsKey)
    }
}
