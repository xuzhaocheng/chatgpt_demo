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
    var shadowRadius: CGFloat = 8.0
    
    func body(content: Content) -> some View {
        content
            .padding(12.0)
            .background(Color.white)
            .cornerRadius(roundedCorners)
            .padding(3.0)
            .foregroundColor(textColor)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.20), radius: shadowRadius)
    }
}
