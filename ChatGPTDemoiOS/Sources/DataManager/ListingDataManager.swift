//
//  ListingDataManager.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/30/24.
//

import Foundation
import OSLog

class ListingDataManager: NSObject {
    static let shared = ListingDataManager()
    
    @Published private(set) var listings: [ListingModel] = []
    
    override private init() {
        super.init()
        
        if let listingsFileUrl = Bundle.main.url(forResource: "listings", withExtension: "plist") {
            let listingsData = try! Data(contentsOf: listingsFileUrl)
            let listingsArray = try! PropertyListSerialization.propertyList(from: listingsData, options: [], format: nil)
            parseListings(listingsArray as! NSArray)
        } else {
            Logger.system.errorAndCache("Error loading listings resource")
        }
    }
    
    private func parseListings(_ listingsArray: NSArray) {
        for listing in listingsArray where listing is NSDictionary {
            let listingDictionary: NSDictionary = listing as! NSDictionary
            
            let listingURLString = listingDictionary["url"] ?? ""
            
            var images: [URL] = []
            if let imageStrings = listingDictionary["images"] as? [String] {
                for imageString in imageStrings {
                    if let imageURL = URL(string: imageString) {
                        images.append(imageURL)
                    } else {
                        Logger.system.errorAndCache("Invalid image url: \(imageString)")
                    }
                }
            }
            
            self.listings.append(
                ListingModel(
                    id: listingDictionary["id"] as! String ,
                    location: listingDictionary["location"] as! String ,
                    title: listingDictionary["title"] as! String,
                    description: listingDictionary["description"] as! String,
                    capacity: listingDictionary["capacity"] as! String,
                    distance: listingDictionary["distance"] as! String,
                    availability: listingDictionary["availability"] as! String,
                    rating: listingDictionary["rating"] as! String,
                    url: URL(string: listingURLString as! String)!,
                    images: images,
                    assistantId: listingDictionary["assistant_id"] as? String)
            )
        }
    }
}
