import SwiftUI

@main
struct ChatGPTDemoApp: App {
    
    var listingViewModel: ListingViewModel = ListingViewModel(ListingDataManager.shared)
//    var chatThreadViewModel: ChatThreadViewModel = ChatThreadViewModel(dataManager: ChatThreadDataManager.shared)
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ListingListView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(listingViewModel)
//            .environmentObject(chatThreadViewModel)
        }
    }
}

extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
