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
	}
}
