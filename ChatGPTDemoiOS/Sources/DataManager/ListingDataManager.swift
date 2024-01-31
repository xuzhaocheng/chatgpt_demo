//
//  ListingDataManager.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/30/24.
//

import Foundation

class ListingDataManager: NSObject {
    static let shared = ListingDataManager()
    
    private(set) var listings: [ListingModel] = []
    
    override private init() {
        super.init()
        
        if let listingsFileUrl = Bundle.main.url(forResource: "listings", withExtension: "plist") {
            let listingsData = try! Data(contentsOf: listingsFileUrl)
            let listingsArray = try! PropertyListSerialization.propertyList(from: listingsData, options: [], format: nil)
            parseListings(listingsArray as! NSArray)
        } else {
            print("Error loading listings resource")
        }
    }
    
    private func parseListings(_ listingsArray: NSArray) {
        for listing in listingsArray where listing is NSDictionary {
            let listingDictionary: NSDictionary = listing as! NSDictionary
            
            let listingURLString = listingDictionary["url"] ?? ""
            
            self.listings.append(
                ListingModel(
                    id: listingDictionary["id"] as! String ,
                    title: listingDictionary["title"] as! String,
                    description: listingDictionary["description"] as! String,
                    distance: listingDictionary["distance"] as! String,
                    availability: listingDictionary["availability"] as! String,
                    rating: listingDictionary["rating"] as! String,
                    url: URL(string: listingURLString as! String))
            )
        }
    }
}
