import SwiftUI

@main
struct ChatGPTDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ThreadView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
