//
//  ProfilePictureViewModifier.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/1/24.
//

import SwiftUI

protocol ImageModifier {
    associatedtype Body: View
    
    func body(image: Image) -> Self.Body
}

extension Image {
    func modifier<M>(_ modifier: M) -> some View where M: ImageModifier {
        modifier.body(image: self)
    }
}

struct ProfilePictureViewModifier: ImageModifier {
    private let size: CGFloat = 40.0
    let rounded: Bool
    
    func body(image: Image) -> some View {
        image
            .resizable()
            .frame(width: size, height: size)
            .cornerRadius(rounded ? size/2 : 0.0)
    }
}
