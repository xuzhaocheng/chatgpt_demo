import SwiftUI

struct ThreadView: View {
    
    var body: some View {
        ZStack {
            Text("Hello from Bazel!  Test 123")
        }.navigationTitle("Chat")
    }
}

struct ThreadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ThreadView()
        }
    }
}
