//
//  ListView.swift
//  NaeRim
//
//  Created by Minjae Kim on 2023/03/20.
//

import SwiftUI
import ExytePopupView
import CoreLocation

struct ListView: View {
	@State private var prkName = ""
	@State private var latitude = 0.0
	@State private var longitude = 0.0
	@State private var shouldShowPopup = false
	@Binding var isShow: Bool
	@Binding var aroundLocationName: String
	@Binding var aroundLocationCoordinate: CLLocationCoordinate2D
	@State private var isShowRoute: Bool = false
	
	@Binding var lots: [Welcome]
	@Binding var minMaxCoordinateDic: [String: Double]
	@EnvironmentObject var locationManager: LocationManager
	var body: some View {
		let filteredItems = lots.flatMap { lot in
			lot.response.body.items.filter { item in
				let itemLatitude = Double(item.latitude) ?? 0.0
				let itemLongitude = Double(item.longitude) ?? 0.0
				return (itemLatitude >= minMaxCoordinateDic["maximumLatitude"] ?? 0.0) && (itemLatitude <= minMaxCoordinateDic["minimumLatitude"] ?? 0.0) &&
				(itemLongitude >= minMaxCoordinateDic["maximumLongitude"] ?? 0.0) && (itemLongitude <= minMaxCoordinateDic["minimumLongitude"] ?? 0.0)
			}
		}
		NavigationView {
			// 길찾기 뷰
			if isShowRoute {
				ShowRouteMap(isShow: $isShowRoute, destinationLatitude: latitude, destinationLogitude: longitude)
			}
			if filteredItems.count > 0 {
				List(filteredItems, id: \.prkplceNm) { item in
					Text(item.prkplceNm)
						.onTapGesture {
							prkName = item.prkplceNm
							latitude = Double(item.latitude) ?? 0.0
							longitude = Double(item.longitude) ?? 0.0
							shouldShowPopup.toggle()
							
							aroundLocationName = item.prkplceNm
							aroundLocationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
						}
				}
				.popup(isPresented: $shouldShowPopup) {
					PopupPrkInfoView(prkName: $prkName, latitude: $latitude, longitude: $longitude, isShow: $shouldShowPopup, isShowRoute: $isShowRoute)
					
				} customize: {
					$0.closeOnTapOutside(true).closeOnTap(false)
				}
				//listStyle을 정해줌
				.listStyle(DefaultListStyle())
				.navigationBarTitle("주변")
				.navigationBarItems(leading: exitButton)
			} else {
				Text("주변 주차장 없습니다.")
			}
		}
	}
	private var exitButton: some View {
		Button {
			isShow = false
		} label: {
			Image(systemName: "xmark")
				.foregroundColor(.black)
		}
	}
}
