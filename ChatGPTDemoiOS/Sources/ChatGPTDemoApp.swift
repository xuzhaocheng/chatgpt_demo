import SwiftUI

@main
struct ChatGPTDemoApp: App {
    
    var chatThreadViewModel: ChatThreadViewModel = ChatThreadViewModel(dataManager: ChatThreadDataManager.shared)
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ThreadList()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(chatThreadViewModel)
        }
    }
}

extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
