//
//  OptionsView.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/3/24.
//

import SwiftUI

struct OptionsView: View {
    @State private var showingClearThreadsPrompt = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Form {
                        Button("Clear ChatGPT Threads") {
                            showingClearThreadsPrompt = true
                        }
                        .alert("Are you sure you want clear ChatGPT Threads from each listing?", isPresented: $showingClearThreadsPrompt) {
                            Button("Cancel", role: .cancel) {
                                
                            }
                            Button("Yes", role: .destructive) {
                                ChatThreadDataManager.shared.clearChatGPTThreads()
                            }
                        }
                    }
                }
                .navigationTitle("Settings")
            }
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
