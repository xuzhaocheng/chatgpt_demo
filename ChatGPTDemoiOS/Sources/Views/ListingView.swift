//
//  ListingView.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/31/24.
//

import SwiftUI

struct ListingView: View {
    let listing: ListingModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            if let previewImage = listing.images?.first {
                ZStack(alignment:Alignment(horizontal: .trailing, vertical: .top)) {
                    AsyncImage(url: previewImage) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                    .cornerRadius(16.0)
                    
                    Image(systemName: "suit.heart")
                        .padding(8.0)
                }
            }

            HStack(alignment: .top) {
                Text(listing.title)
                Spacer()
                HStack{
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 12.0, height: 12.0)
                    Text(listing.rating)
                }
            }
            Text(listing.availability)
                .font(.system(.caption))
        }
        .padding(.vertical)
    }
}
