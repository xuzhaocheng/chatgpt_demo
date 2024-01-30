//
//  Contact.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/25/24.
//

import Foundation

struct Contact {
    let id: String
    let name: String
    
    init(id: String = UUID().uuidString, name: String) {
        self.id = id
        self.name = name
    }
}
