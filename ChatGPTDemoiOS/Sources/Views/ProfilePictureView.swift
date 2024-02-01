//
//  PorfilePictureView.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/17/24.
//

import SwiftUI

struct ProfilePictureView: View {
    let profilePictureUrl: URL?
    
    init(_ url: URL?) {
        self.profilePictureUrl = url
    }
    
    var body: some View {
        guard let url = self.profilePictureUrl,
              let uiImage = UIImage(contentsOfFile: url.path())
        else {
            return
            Image(systemName: "person.crop.circle")
                .modifier(ProfilePictureViewModifier(rounded: false))
        }
        
        return
        Image(uiImage: uiImage)
            .modifier(ProfilePictureViewModifier(rounded: true))
    }
}
