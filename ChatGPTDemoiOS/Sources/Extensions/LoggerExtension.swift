//
//  LoggerExtension.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/3/24.
//

import Foundation
import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Default system logs
    static let system = Logger(subsystem: subsystem, category: "data")
}
