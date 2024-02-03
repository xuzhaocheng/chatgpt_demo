//
//  MessageCellView.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/1/24.
//

import SwiftUI

struct MessageCellView: View {
    var messageModel: ChatMessageModel
    private let dateFormatter: DateFormatter = DateFormatter()
    
    init(messageModel: ChatMessageModel) {
        self.messageModel = messageModel
        self.dateFormatter.dateFormat = "hh:mm a"
    }
    
    var body: some View {
        HStack(alignment: .top) {
            ProfilePictureView(messageModel.sender.profilePictureUrl)

            VStack(alignment: .leading) {
                HStack {
                    Text(messageModel.sender.name)
                        .bold()
                    Text(dateFormatter.string(from: Date(timeIntervalSince1970: messageModel.sentTimestamp)))
                }
                
                if messageModel.type == .placeholder {
                    LoadingCirclesView()
                } else {
                    Text(messageModel.message)
                }
            }
            Spacer()
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .padding()
    }
    
//    private func _imageFromMainBundle(name: String, type: String = "jpeg") -> UIImage? {
//        guard let path = Bundle.main.path(forResource: name, ofType: type)
//              else { return nil }
//        
//        return UIImage(contentsOfFile: path)
//    }
}
