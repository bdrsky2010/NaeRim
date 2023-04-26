//
//  LocalSearchView.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/04/13.
//

import SwiftUI
import CoreLocation

struct LocalSearchView: View {
	@Binding var isSearchList: Bool
	@Binding var searchLocationCoordinate: CLLocationCoordinate2D
	var body: some View {
		LocalSearchListView(isSearchList: $isSearchList, searchLocationCoordinate: $searchLocationCoordinate)
			.padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
	}
}
