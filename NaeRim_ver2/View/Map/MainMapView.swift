//
//  MainMapView.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/04/15.
//

import SwiftUI
import CoreLocation

struct MainMapView: View {
	@State private var isSearchList = false
	@StateObject var locationManager: LocationManager = .init()
	@ObservedObject var requestAPI = RequestAPI()
	@State private var parkingLotInfo: [Item] = []
	
	// 주변 주차장 리스트
	@Binding var aroundLocationName: String
	@Binding var aroundLocationCoordinate: CLLocationCoordinate2D
	@State private var currentAroundLocationName: String = ""
	@State private var currentAroundLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
	
	// 즐겨찾기 주차장 리스트
	
	// 장소검색 주변 주차장 리스트
	@State private var searchLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
	
		var body: some View {
			ZStack {
				MapViewSelection().environmentObject(locationManager)
					.onAppear {
//						requestAPI.getParkingAPI()
					}
					.onChange(of: aroundLocationCoordinate) { newValue in
						if newValue.latitude != 0.0 && newValue.longitude != 0.0 {
							locationManager.searchPointMapViewFocusChange(newValue.latitude, newValue.longitude)
							locationManager.addPin(aroundLocationName, newValue.latitude, newValue.longitude)
					
							self.currentAroundLocationCoordinate = CLLocationCoordinate2D(latitude: newValue.latitude, longitude: newValue.longitude)
						}
					}
					.onChange(of: searchLocationCoordinate) { newValue in
						if newValue.latitude != 0.0 && newValue.longitude != 0.0 {
							locationManager.searchPointMapViewFocusChange(newValue.latitude, newValue.longitude)
							locationManager.addPin(aroundLocationName, newValue.latitude, newValue.longitude)
						}
					}
					
				VStack {
					EmptyShellSearchBar(currentAddress: $locationManager.currentAddress)
						.padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
						.onTapGesture {
							isSearchList = true
						}
					Spacer()
				}
			}
			.fullScreenCover(isPresented: $isSearchList) {
				LocalSearchView(isSearchList: $isSearchList, searchLocationCoordinate: $searchLocationCoordinate)
			}
		}
}

//struct MainMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainMapView()
//    }
//}
