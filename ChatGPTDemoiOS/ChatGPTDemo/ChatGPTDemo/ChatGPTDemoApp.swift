//
//  ChatGPTDemoApp.swift
//  ChatGPTDemo
//
//  Created by Thuan Nguyen on 8/19/23.
//

import SwiftUI

@main
struct ChatGPTDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
