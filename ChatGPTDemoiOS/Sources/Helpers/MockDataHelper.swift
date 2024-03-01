//
//  PreviewHelper.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/31/24.
//

import Foundation

struct MockDataHelper {
    static var mockListing: ListingModel {
        ListingModel(
            id: "49986215",
            location: "Austin, TX",
            title: "Camper/RV in Half Moon Bay, California",
            description: "Test description",
            capacity: "12 guests • 3 bedrooms • 6 beds • 3 baths",
            distance: "50 miles away",
            availability: "5 nights * Feb 4- 9",
            rating: "4.97",
            url: URL(string: "https://www.airbnb.com/rooms/49986215")!,
            images: [URL(string: "https://a0.muscache.com/im/pictures/38691cf9-b5c6-4052-bc79-60ea4a6ace72.jpg?im_w=1200")!],
            assistantId: nil)
    }
    
    static var mockChatThreadModel: ChatThreadModel {
        ChatThreadModel(
            chatgptThreadId: nil,
            title: "Sam Smith",
            snippet: "Hi the Airbnb is available",
            status: "Canceled * Apr 11 - 14, 2022",
            isRead: false,
            listing:mockListing)
    }
    
    static var mockMessages: [ChatMessageModel] {
        let chatThreadModel = mockChatThreadModel;

        let selfSender = MockDataHelper.selfContact
        let airGPT = MockDataHelper.airGPTContact

        return [
            ChatMessageModel(sentTimestamp: Date().timeIntervalSince1970, sender: airGPT, message: "Hi this is AirGPT assistant, how can I help you?", chatThread: chatThreadModel),
            ChatMessageModel(sentTimestamp: Date().timeIntervalSince1970, sender: selfSender, message: "Hi can I get more info on the rental?", chatThread: chatThreadModel),
            ChatMessageModel(sentTimestamp: Date().timeIntervalSince1970, sender: airGPT, message: "I'm happy to assist you, one moment", chatThread: chatThreadModel)
        ]
    }
    
    static var selfContact: Contact {
        Contact(name: "Thuan", isSelf: true, profilePictureUrl: Bundle.main.url(forResource: "thuan", withExtension: "jpeg")!)
    }
    
    static var airGPTContact: Contact {
        var llvmName = ""
        switch ChatThreadDataManager.shared.llvmPreference() {
        case .chatGPT:
            llvmName = "ChatGPT"
        case .ollama:
            llvmName = "Ollama"
        case .lmStudio:
            llvmName = "LM Studio"
        }
        
        return
        Contact(name: "AirGPT (\(llvmName))", isSelf: false, profilePictureUrl: Bundle.main.url(forResource: "airbnb", withExtension: "jpeg")!)
    }
    
    static func airGPTMessage(messageType: ChatMessageType = .normal, message: String, chatThread: ChatThreadModel) -> ChatMessageModel {
        ChatMessageModel(sentTimestamp: Date().timeIntervalSince1970, sender: MockDataHelper.airGPTContact, message: message, chatThread: chatThread)
    }
    
    static func initialWelcomeMessages(chatThreadModel: ChatThreadModel) -> [ChatMessageModel] {
        let chatThreadModel = mockChatThreadModel;

        return [
            ChatMessageModel(sentTimestamp: Date().timeIntervalSince1970, sender: MockDataHelper.airGPTContact, message: "Hi this is AirGPT assistant, how can I help you?", chatThread: chatThreadModel),
        ]
    }
    
    static func airGPTPlaceholderMessage(chatThread: ChatThreadModel) -> ChatMessageModel {
        ChatMessageModel(type: .placeholder, sentTimestamp: Date().timeIntervalSince1970, sender: MockDataHelper.airGPTContact, message: "", chatThread: chatThread)
    }
}
