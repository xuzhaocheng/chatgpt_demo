//
//  SearchButtonViewModifier.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/31/24.
//

import SwiftUI

struct RoundedCornersViewModifier: ViewModifier {
    var roundedCorners: CGFloat
    var textColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(roundedCorners)
            .padding(3.0)
            .foregroundColor(textColor)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.20), radius: 8.0)
    }
}
