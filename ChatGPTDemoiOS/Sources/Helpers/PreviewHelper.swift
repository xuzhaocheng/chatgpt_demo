//
//  PreviewHelper.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/31/24.
//

import Foundation

struct PreviewHelper {
    static var listing: ListingModel {
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
            images: [URL(string: "https://a0.muscache.com/im/pictures/38691cf9-b5c6-4052-bc79-60ea4a6ace72.jpg?im_w=1200")!])
    }
    
    static var chatThreadModel: ChatThreadModel {
        ChatThreadModel(
            chatgptThreadId: nil,
            title: "Sam Smith",
            snippet: "Hi the Airbnb is available",
            status: "Canceled * Apr 11 - 14, 2022",
            isRead: false,
            listing:listing)
    }
    
    static var messages: [ChatMessageModel] {
        []
    }
}