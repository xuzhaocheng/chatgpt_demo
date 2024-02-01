//
//  ThreadView.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/16/24.
//

import SwiftUI

struct ThreadView: View {
    @ObservedObject private var chatThreadViewModel: ChatThreadViewModel
    
    var chatThread: ChatThreadModel
    
//    @State var messages: [ChatMessageModel] = []
    @State var textFieldText: String = ""
    @FocusState var isTextFieldFocused: Bool
    
    init(chatThread: ChatThreadModel) {
        self.chatThread = chatThread
        self.chatThreadViewModel = ChatThreadViewModel(dataManager: ChatThreadDataManager.shared, chatThread: chatThread)
    }
    
    var body: some View {
        VStack {
            Divider()
            ThreadViewBanner(listing: chatThread.listing!)
                .padding(.vertical)
            Divider()
            ScrollView {
                ForEach(chatThreadViewModel.messages) { message in
                    MessageCellView(messageModel: message)
                }
            }
            .frame(alignment: .leading)
            GrowingTextField(onSend: { message in
                print("Sending \(message)")
            })
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("AirGPT")
        .task {
            chatThreadViewModel.loadMessages(chatThread)
        }
    }
}

struct ThreadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ThreadView(
                chatThread:PreviewHelper.chatThreadModel)
        }
    }
}
