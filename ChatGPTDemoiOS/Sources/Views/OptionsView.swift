//
//  OptionsView.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 2/3/24.
//

import SwiftUI
import OSLog

struct OptionsView: View {
    @State private var showingClearThreadsPrompt = false
    @State private var showingClearLogsPrompt = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Options")) {
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
                    
                    Button("Clear Logs") {
                        showingClearLogsPrompt = true
                    }
                    .alert("Are you sure you want clear logs?", isPresented: $showingClearLogsPrompt) {
                        Button("Cancel", role: .cancel) {
                            
                        }
                        Button("Yes", role: .destructive) {
                            Logger.logsToDisplay.removeAll()
                        }
                    }
                }
                
                Section(header: Text("Logs")) {
                    ForEach(Logger.logsToDisplay.reversed(), id: \.self) { log in
                        Text(log.formattedLogString())
                            .foregroundStyle(log.logLevel == .error ? .red : .black)
                            .fontWeight(log.logLevel == .error ? .bold : .regular)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        Logger.logsToDisplay = [
            DisplayLog(.error, log: "This is an error"),
            DisplayLog(.info, log: "This is an info"),
            DisplayLog(.error, log: "This is an error"),
            DisplayLog(.info, log: "This is an info"),
        ]
        
        return OptionsView()
    }
}
