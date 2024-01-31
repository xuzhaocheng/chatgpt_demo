//
//  ListingModel.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/30/24.
//

import Foundation

struct ListingModel: Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let distance: String
    let availability: String
    let rating: String
    let url: URL
    let images: [URL]?
}
