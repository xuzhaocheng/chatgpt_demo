//
//  Contact.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/25/24.
//

import Foundation

struct Contact: Identifiable, Hashable {
    let id: String
    let name: String
    let isSelf: Bool
    let profilePictureUrl: URL?
    
    init(id: String = UUID().uuidString, name: String, isSelf: Bool, profilePictureUrl: URL?) {
        self.id = id
        self.name = name
        self.isSelf = isSelf
        self.profilePictureUrl = profilePictureUrl
    }
}
