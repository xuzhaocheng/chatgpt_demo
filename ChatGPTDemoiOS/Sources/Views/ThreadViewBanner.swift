//
//  ThreadViewBanner.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/31/24.
//

import SwiftUI

struct ThreadViewBanner: View {
    let listing: ListingModel
    
    var body: some View {
        HStack {
            AsyncImage(url: listing.images?.first) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: 40.0, maxHeight: 40.0)
            .cornerRadius(6.0)
            
            VStack(alignment: .leading) {
                Text(listing.title)
                    .font(.headline)
                Text(listing.availability)
            }
        }
    }
}

struct ThreadViewBanner_Previews: PreviewProvider {
    static var previews: some View {
        ThreadViewBanner(listing: MockDataHelper.mockListing)
    }
}
