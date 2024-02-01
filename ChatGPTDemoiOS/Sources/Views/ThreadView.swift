//
//  ThreadView.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/16/24.
//

import SwiftUI

struct ThreadView: View {
    var chatThread: ChatThreadModel
    
    var body: some View {
        VStack {
            Divider()
            ScrollView {
                Text("Hello")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(chatThread.listing!.title)
    }
}

struct ThreadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ThreadView(
                chatThread:
                    ChatThreadModel(
                        chatgptThreadId: nil,
                        title: "Sam Smith",
                        snippet: "Hi the Airbnb is available",
                        status: "Canceled * Apr 11 - 14, 2022",
                        isRead: false,
                        listing:
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
                                images: [URL(string: "https://a0.muscache.com/im/pictures/38691cf9-b5c6-4052-bc79-60ea4a6ace72.jpg?im_w=1200")!])))
        }
    }
}
