//
//  ListRowView.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/17/24.
//

import SwiftUI

struct ListRowView: View {
    let chatThread: ChatThreadModel
    
    var body: some View {
        HStack {
            ProfilePictureView()
                .frame(width: 60.0, height: 60.0)
                .padding(EdgeInsets(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 8.0))
            VStack {
                Text(chatThread.title)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(chatThread.snippet)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if let status = chatThread.status {
                    Text(status)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        ListRowView(chatThread: ChatThreadModel(title: "John Smith", snippet: "How are you?", status: "Request widthdrawn", isRead: false))
    }
}

