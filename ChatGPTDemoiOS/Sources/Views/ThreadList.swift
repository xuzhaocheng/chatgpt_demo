//
//  ThreadList.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/16/24.
//

import SwiftUI

struct ThreadList: View {
    @EnvironmentObject var chatThreadViewModel: ChatThreadViewModel
    
    var body: some View {
        ZStack {
            List {
                Section() {
                    ForEach(chatThreadViewModel.chatThreads) { chatThread in
                        ZStack {
                            ListRowView(chatThread: chatThread)
                            NavigationLink(destination: ThreadView(chatThread: chatThread)) {
                                EmptyView()
                            }
                            .opacity(0.0)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .listSectionSeparator(.hidden, edges: .top)
            }
            .padding(EdgeInsets(top: 40.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
        }
        .navigationTitle("Inbox")
        .listStyle(PlainListStyle())
    }
}

struct ThreadList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ThreadList()
                .environmentObject(ChatThreadViewModel())
        }
    }
}
