//
//  LocalSearchListView.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/04/08.
//

import SwiftUI

struct LocalSearchListView: View {
	@State private var isShow = false
	@State private var searchText = ""
	@ObservedObject var search = KeyWordSearch()
	
	var body: some View {
		VStack {
			SearchBar(text: $searchText)
				.frame(width: 380)
			if !search.searchResults.isEmpty {
				List(search.searchResults, id: \.self) { result in
					VStack(alignment: .leading) {
						Text(result.placeName)
						HStack {
							Text(result.addressName)
								.font(.caption)
								.foregroundColor(.gray)
							Spacer()
							let distance = Double(result.distance)
							Text("\(String(format: "%.2f", (distance ?? 0.0)/1000)) Km")
								.font(.caption2)
								.foregroundColor(.gray)
						}
					}
				}
			}
		}
		.onChange(of: searchText) { newValue in
			search.query = newValue
			search.searchResults.removeAll()
		}
	}
}

struct LocalSearchListView_Previews: PreviewProvider {
	static var previews: some View {
		LocalSearchListView()
	}
}
