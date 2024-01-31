//
//  ListingListView.swift
//  ChatGPTDemoApp
//
//  Created by Thuan Nguyen on 1/31/24.
//

import SwiftUI

struct ListingListView: View {
    @EnvironmentObject var listingViewModel: ListingViewModel
    @State var textFieldString: String = ""
    
    var body: some View {
        let listings = listingViewModel.listings
        VStack {
            Button(action: searchButtonAction, label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 30.0, height: 30.0)
                    Spacer()
                        .frame(width: 20)
                    VStack(alignment: .leading) {
                        Text("Where to?")
                            .font(.system(.headline, design: .rounded))
                        Text("Anywhere • Any week • Add guest")
                            .font(.system(.caption, design: .rounded))
                    }
                    Spacer()
                }
                .modifier(SearchButtonViewModifier(roundedCorners: 30.0, textColor: Color.black))
            })
            ScrollView(showsIndicators: false) {
                ForEach(listings) { listing in
                    ListingView(listing: listing)
                }
            }
        }
        .padding(30)
    }
    
    func searchButtonAction() {
        
    }
}

struct ListingListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListingListView()
                .environmentObject(ListingViewModel(ListingDataManager.shared))
        }
    }
}

