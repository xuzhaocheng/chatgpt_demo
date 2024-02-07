//
//  URLCache+imageCache.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/6/24.
//

import Foundation

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512_000_000, diskCapacity: 10_000_000_000)
}
