//
//  ThreadView.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/16/24.
//

import SwiftUI

struct ThreadView: View {
    var chatThread: ChatThreadModel
    @State var textFieldText: String = ""
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        VStack {
            Divider()
            ThreadViewBanner(listing: chatThread.listing!)
                .padding(.vertical)
            Divider()
            ScrollView {
                HStack(alignment: .top) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Thuan")
                                .bold()
                            Text("9:24 PM")
                        }
                        Text("Hi how are you doing?  Is this available now?  I would like to book it")
                    }
                    Spacer()
                    
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding()
            }
            .frame(alignment: .leading)
//            .padding()
            
            GrowingTextField()
//            TextField("Write a message", text: $textFieldText, onEditingChanged: _editMode)
//                .textFieldStyle(.roundedBorder)
//                .padding(.horizontal)
//                .padding(.bottom)
//                .lineLimit(5, reservesSpace: true)
//                .frame(height: 80.0)
//                .focused($isTextFieldFocused)
//                .overlay {
////                    if (isTextFieldFocused) {
//                        HStack {
//                            Spacer()
//                            Button {
//                                textFieldText = ""
//                            } label: {
//                                Image(systemName: "arrow.up.circle.fill")
//                            }
//                            .foregroundColor(.secondary)
//                            .padding(.trailing, 24.0)
//                            .padding(.bottom, 16.0)
//                        }
////                    }
//                }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("AirGPT")
    }
    
    private func _editMode(_ isEditing: Bool) {
        
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
