//
//  ChatThreadListView.swift
//  ChatGPTDemo
//
//  Created by Thuan Nguyen on 10/2/23.
//

import SwiftUI
import CoreData

struct ChatThreadListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ChatThread.lastActivityTimestamp, ascending: true)],
        animation: .default)
    private var chatThreads: FetchedResults<ChatThread>
    
    var body: some View {
        List {
            ForEach(chatThreads) { chatThread in
                Text("\(chatThread.title!) \(chatThread.lastActivityTimestamp!.timeIntervalSince1970)")
            }
        }
    }
}

struct ChatThreadListView_Preview : PreviewProvider {
    static var previews: some View {
        ChatThreadListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
