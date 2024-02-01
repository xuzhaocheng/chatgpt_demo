//
//  MessageCellView.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/1/24.
//

import SwiftUI

struct MessageCellView: View {
    var messageModel: ChatMessageModel
    
    var body: some View {
        HStack(alignment: .top) {
            ProfilePictureView(messageModel.sender.profilePictureUrl)
//            if let uiImage = UIImage(contentsOfFile: messageModel.sender.profilePictureUrl.path()) {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .frame(width: 40.0, height: 40.0)
//            } else {
//                Image(systemName: "person.crop.circle")
//                    .resizable()
//                    .frame(width: 40.0, height: 40.0)
//            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(messageModel.sender.name)
                        .bold()
                    Text("9:24 PM")
                }
                Text(messageModel.message)
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
