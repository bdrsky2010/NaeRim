//
//  LocalSearchListView.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/04/08.
//

import SwiftUI
import CoreLocation

struct LocalSearchListView: View {
	@State private var searchText = ""
	@ObservedObject var search = KeyWordSearch()
	@State private var placeName = ""
	@State private var latitude = 0.0
	@State private var longitude = 0.0
	@State private var isShowMap = false
	@Binding var isSearchList: Bool
	@Binding var searchLocationCoordinate: CLLocationCoordinate2D
	var body: some View {
		NavigationView {
			VStack {
				SearchBar(text: $searchText, isSearchList: $isSearchList)
					.frame(width: 350, height: 50)
					.onTapGesture {
						isShowMap = false
					}
				//				List(search.searchResults, id: \.self) { result in
				//					NavigationLink(destination: LocalSearchSelectMapView(placeName: result.placeName, latitude: Double(result.y) ?? 0.0, longitude: Double(result.x) ?? 0.0)) {
				//						VStack(alignment: .leading) {
				//							Text(result.placeName)
				//							HStack {
				//								Text(result.addressName)
				//									.font(.caption)
				//									.foregroundColor(.gray)
				//								Spacer()
				//								let distance = Double(result.distance)
				//								Text("\(String(format: "%.2f", (distance ?? 0.0)/1000)) Km")
				//									.font(.caption2)
				//									.foregroundColor(.gray)
				//							}
				//						}
				//					}
				//				}
				ZStack {
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
							.onTapGesture {
								isShowMap = true
								placeName = result.placeName
								latitude = Double(result.y) ?? 0.0
								longitude = Double(result.x) ?? 0.0
								searchLocationCoordinate = CLLocationCoordinate2D(latitude: Double(result.y) ?? 0.0, longitude: Double(result.x) ?? 0.0)
							}
						}
					.scrollContentBackground(.hidden)
					.navigationBarTitle("장소검색", displayMode: .automatic)
					.navigationBarHidden(true)
					if isShowMap {
						LocalSearchSelectMapView(placeName: placeName, latitude: latitude, longitude: longitude)
					}
				}
			}
			.onChange(of: searchText) { newValue in
				search.query = newValue
				search.searchResults.removeAll()
			}
		}
	}
}
