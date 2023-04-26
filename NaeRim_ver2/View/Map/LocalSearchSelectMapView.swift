//
//  LocalSearchSelectMapView.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/04/14.
//

import Foundation
import SwiftUI
import CoreLocation
import ExytePopupView

struct LocalSearchSelectMapView: View {
	let placeName: String
	let latitude: Double
	let longitude: Double
	
	@State private var prkName = ""
	@State private var prkLatitude = 0.0
	@State private var prkLongitude = 0.0
	@State private var shouldShowPopup = false
	
	@StateObject private var locationManager: LocationManager = .init()
//	@StateObject var firebase = FireStoreManager()
	var body: some View {
		MapViewSelection().environmentObject(locationManager)
			.onAppear {
//				locationManager.searchGeoPint = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
				locationManager.searchPointMapViewFocusChange(latitude, longitude)
				locationManager.addPin(placeName, latitude, longitude)
			}
		let dic = locationManager.calcMaxMinCoordinate()
//		let filteredItems = firebase.items.filter { item in
//			let itemLatitude = item.latitude
//			let itemLongitude = item.longitude
//			return (itemLatitude >= dic["maximumLatitude"]! && itemLatitude <= dic["minimumLatitude"]!) &&
//			(itemLongitude >= dic["maximumLongitude"]! && itemLongitude <= dic["minimumLongitude"]!)
//		}
//		NavigationView {
//			List(filteredItems, id: \.prkplceNo) { item in
//				Text(item.prkplceNm)
//					.onAppear {
//						locationManager.addPin(item.prkplceNm, item.latitude, item.longitude)
//					}
//					.onTapGesture {
//						prkName = item.prkplceNm
//						prkLatitude = item.latitude
//						prkLongitude = item.longitude
//						shouldShowPopup.toggle()
//					}
//			}
//			.popup(isPresented: $shouldShowPopup) {
//				PopupPrkInfoView(prkName: $prkName, latitude: $prkLatitude, longitude: $prkLongitude)
//
//			} customize: {
//				$0.closeOnTapOutside(true).closeOnTap(false)
//			}
//			.listStyle(.inset)
//			.navigationTitle("주변 주차장")
//			.navigationBarTitleDisplayMode(.inline)
//			.navigationBarItems(trailing: editButton)
//		}
	}
	private var editButton: some View {
		Menu {
			Menu("주차장 구분") {
				Button("없음", action: emptyFunc)
				Button("공영", action: emptyFunc)
				Button("민영", action: emptyFunc)
			}
			Menu("주차장 유형") {
				Button("없음", action: emptyFunc)
				Button("노외", action: emptyFunc)
				Button("노상", action: emptyFunc)
				Button("부설", action: emptyFunc)
			}
			Menu("요금정보") {
				Button("없음", action: emptyFunc)
				Button("유료", action: emptyFunc)
				Button("무료", action: emptyFunc)
				Button("혼합", action: emptyFunc)
			}
		} label: {
			Image(systemName: "slider.horizontal.3")
		}
	}
	func emptyFunc() { }
}
