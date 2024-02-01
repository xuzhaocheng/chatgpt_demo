//
//  GrowingTextField.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/1/24.
//

import SwiftUI

struct GrowingTextField: View {
    @State var message: String = ""
    @FocusState var isTextFieldFocused: Bool
    
    var onSend: ((String) -> ())?
    var onFocusChanged: ((Bool) -> ())?
    
    var body: some View {
        HStack(alignment: .bottom) {
            HStack(spacing: 8) {
                withAnimation(.easeInOut) {
                    TextField("", text: $message, axis: .vertical)
                        .placeholder(when: message.isEmpty) {
                            Text("Write a message")
                                .foregroundColor(.secondary)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 40.0))
                        // Add maximum vertical visible line limit
                        .lineLimit(...4)
                        .focused($isTextFieldFocused)
                        .onChange(of: isTextFieldFocused) { isFocused in
                            if let focusChanged = onFocusChanged {
                                focusChanged(isFocused)
                            }
                        }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.white)
            .modifier(RoundedCornersViewModifier(roundedCorners: 30.0, textColor: Color.black))
            .overlay {
                // Send button
                VStack(alignment: .trailing) {
                    HStack(alignment: .bottom) {
                        Spacer()
                        VStack(alignment: .trailing) {
                            Spacer()
                            if message != "" {
                                Button {
                                    // send something
                                    if let sendAction = onSend  {
                                        sendAction(message)
                                        message = ""
                                    }
                                } label: {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(Color(.black))
                                }
                            } else {
                                Button {
                                    // make something
                                } label: {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(Color(.systemGray4))
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                    .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .padding(.trailing)
                }
            }
        }
        .padding(.leading , 14)
        .padding(.trailing, 10)
        .padding(.vertical, 7)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 55)
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.3), value: message)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        GrowingTextField()
    }
}
