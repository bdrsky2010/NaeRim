//
//  LocationManager.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/04/06.
//

import SwiftUI
import MapKit
import CoreLocation
// MARK: Combine Framework to watch Textfield Change
import Combine

class LocationManager: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
	// MARK: Properties
	@Published var mapView: MKMapView = .init()
	@Published var manager: CLLocationManager = .init()
	
	// MARK: Search Bar Test
	@Published var searchText: String = ""
	var cancellable: AnyCancellable?
	@Published var fetchPlaces: [CLPlacemark]?
	
	// MARK: User Location
	@Published var userLocation: CLLocation?
	
	override init() {
		super.init()
		// MARK: Setting Delegates
		manager.delegate = self
		mapView.delegate = self
		
		// MARK: Requesting Location Access
		manager.requestWhenInUseAuthorization()
		
		// MARK: Search Textfield Watching
		cancellable = $searchText
			.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
			.removeDuplicates()
			.sink(receiveValue: { value in
				if value != "" {
					self.fetchPlaces(value: value)
				} else {
					self.fetchPlaces = nil
				}
			})
	}
	
	func fetchPlaces(value: String) {
		// MARK: Fetching places using MKLocalSearch $ Asyc/Await
		Task {
			do {
				let request = MKLocalSearch.Request()
				request.naturalLanguageQuery = value.lowercased()
				
				let response = try await MKLocalSearch(request: request).start()
				// We can also Use Mainactor To publish changes in Main Thread
				await MainActor.run(body: {
					self.fetchPlaces = response.mapItems.compactMap({ item -> CLPlacemark? in
						return item.placemark
					})
				})
			}
			catch {
				// HANDLE ERROR
			}
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		// HANDLE ERROR
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let currentLocation = locations.last else { return }
		self.userLocation = currentLocation
	}
	
	// MARK: Location Authorization
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		switch manager.authorizationStatus {
		case .authorizedAlways: manager.requestLocation()
		case .authorizedWhenInUse: manager.requestLocation()
		case .denied: handleLocationError()
		case .notDetermined: manager.requestWhenInUseAuthorization()
		default: ()
		}
	}
	
	func handleLocationError() {
		
	}
}
