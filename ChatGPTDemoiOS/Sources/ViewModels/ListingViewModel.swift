//
//  ListingViewModel.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/31/24.
//

import Foundation

class ListingViewModel: ObservableObject {
    @Published private var listingDataManager: ListingDataManager
    
    var listings: [ListingModel] {
        self.listingDataManager.listings
    }
    
    init(_ listingDataManager: ListingDataManager) {
        self.listingDataManager = listingDataManager
    }
}
