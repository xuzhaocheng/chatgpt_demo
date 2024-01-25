//
//  ChatThreadDataManager.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/23/24.
//

import Foundation
import CoreData

enum ChatThreadDataManagerType {
    case normal
}

class ChatThreadDataManager: NSObject, ObservableObject {
    
    static let shared = ChatThreadDataManager(type: .normal)
    
    fileprivate var managedObjectContext: NSManagedObjectContext
    
    private init(type: ChatThreadDataManagerType) {
        switch type {
        case .normal:
            let persistantStore = PersistantStore()
            self.managedObjectContext = persistantStore.context
        }
        
        super.init()
    }
    
    func saveData() {
        if (self.managedObjectContext.hasChanges) {
            do {
                try self.managedObjectContext.save()
            } catch let error as NSError {
                print("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
    
    func createChatThread() {
//        let chatThread =  ChatThread(context: self.managedObjectContext) 
    }
}
