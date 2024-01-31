//
//  ChatThreadViewModel.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/17/24.
//

import Foundation

class ChatThreadViewModel: ObservableObject {
    
    @Published private var dataManager: ChatThreadDataManager
    
    init(dataManager: ChatThreadDataManager) {
        self.dataManager = dataManager
        let _ = ListingDataManager.shared
    }
    
    @Published var chatThreads: [ChatThreadModel] = [
        ChatThreadModel(chatgptThreadId: nil, title: "Sam Smith", snippet: "Hi the Airbnb is available", status: "Canceled * Apr 11 - 14, 2022", isRead: false, listing: nil),
        ChatThreadModel(chatgptThreadId: nil, title: "Mary Jane", snippet: "How are you?", status: nil, isRead: true, listing: nil)
    ]
}
