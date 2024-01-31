//
//  ListingDetailView.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/31/24.
//

import SwiftUI

struct ListingDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isExpanded: Bool = false

    let listing: ListingModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                ZStack(alignment:Alignment(horizontal: .leading, vertical: .top)) {
                    AsyncImage(url: listing.images?.first) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.white)
                            .padding(EdgeInsets(top: 60.0, leading: 16.0, bottom: 0.0, trailing: 16.0))
                    }
                }
                
                VStack(alignment: .leading, spacing: 12.0)  {
                    Text(listing.title)
                        .font(.system(.title3))
                    Text("Entire home in \(listing.location)")
                    Text(listing.capacity)
                    
                    HStack(alignment: .center) {
                        VStack {
                            Text(listing.rating)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
//                            Spacer()
                        Divider().frame(maxHeight: 32.0)
                        VStack {
                            Text("Guest Favorite")
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
//                            Spacer()
                        Divider().frame(maxHeight: 32.0)
                        VStack {
                            Text("100\nReviews")
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
//                    .padding(EdgeInsets(top: 24.0, leading: 16.0, bottom: 24.0, trailing: 16.0))
                    .frame(maxWidth: .infinity)
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 8.0)
                            .stroke(.gray, lineWidth: 1)
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                Divider()
                Text(listing.description)
                    .lineLimit(isExpanded ? nil : 6)
                    .overlay(
                        GeometryReader { proxy in
                            Button(action: {
                                isExpanded.toggle()
                            }) {
                                Text(isExpanded ? "Less" : "More")
                                    .font(.caption).bold()
                                    .padding(.leading, 8.0)
                                    .padding(.top, 4.0)
                                    .background(Color.white)
                            }
                            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottomTrailing)
                        }
                    )
//                Spacer()
            }
        }
        .statusBar(hidden: true)
        .edgesIgnoringSafeArea(.top)
    }
}

struct ListingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPresenting: Bool = false
        
        NavigationView {
            ListingDetailView(
                listing:
                    ListingModel(
                        id: "49986215",
                        location: "Austin, TX",
                        title: "Camper/RV in Half Moon Bay, California",
                        description: "Test description",
                        capacity: "12 guests • 3 bedrooms • 6 beds • 3 baths",
                        distance: "50 miles away",
                        availability: "5 nights * Feb 4- 9",
                        rating: "4.97",
                        url: URL(string: "https://www.airbnb.com/rooms/49986215")!,
                        images: [URL(string: "https://a0.muscache.com/im/pictures/38691cf9-b5c6-4052-bc79-60ea4a6ace72.jpg?im_w=1200")!]))
        }
    }
}

