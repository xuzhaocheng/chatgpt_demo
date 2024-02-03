//
//  LoadingCirclesView.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/2/24.
//

import SwiftUI

struct LoadingCirclesView: View {
    
    @State private var shouldAnimate = false
    private var size: CGFloat = 10.0
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.blue)
                .frame(width: size, height: size)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever())
            Circle()
                .fill(Color.blue)
                .frame(width: size, height: size)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3))
            Circle()
                .fill(Color.blue)
                .frame(width: size, height: size)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6))
        }
        .onAppear {
            self.shouldAnimate = true
        }
    }
    
}
