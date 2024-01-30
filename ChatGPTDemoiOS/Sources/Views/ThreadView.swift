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
        ZStack {
            Text("Hello from Bazel!  Test 123")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text(chatThread.title)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("...") {
                    
                }
            }
        }
    }
}

struct ThreadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ThreadView(chatThread: ChatThreadModel(chatgptThreadId: nil, title: "Sam Smith", snippet: "Hi the Airbnb is available", status: "Canceled * Apr 11 - 14, 2022", isRead: false, listing: nil))
        }
    }
}
