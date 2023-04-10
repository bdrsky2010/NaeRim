//
//  PopupMap.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/03/30.
//

import SwiftUI
import MapKit

struct ParkingLoc: Codable, Identifiable {
	var id = UUID()
	var latitude, longitude: Double
	//Computed Property
	var location: CLLocationCoordinate2D {
		CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}
}

struct PopupMap: View {
	@Binding var prkName: String
	@Binding var latitude: Double
	@Binding var longitude: Double
	private let initialLatitudinalMetres: Double = 350
	private let initialLongitudinalMetres: Double = 350
	
	@State private var span: MKCoordinateSpan?
	init(prkName: Binding<String>, latitude: Binding<Double>, longitude: Binding<Double>) {
		_prkName = prkName
		_latitude = latitude
		_longitude = longitude
	}
	
	private var region: Binding<MKCoordinateRegion> {
		Binding {
			let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			
			if let span = span {
				return MKCoordinateRegion(center: center, span: span)
			} else {
				return MKCoordinateRegion(center: center, latitudinalMeters: initialLatitudinalMetres, longitudinalMeters: initialLongitudinalMetres)
			}
		}
		set: { region in
//			latitude = region.center.latitude
//			longitude = region.center.longitude
//			span = region.span
		}
	}
	
	var body: some View {
		Map(coordinateRegion: region, interactionModes: [.all], showsUserLocation: true, annotationItems: [ParkingLoc(latitude: latitude, longitude: longitude)]) { location in
			// Use MapAnnotation instead of MapMarker
			MapAnnotation(coordinate: location.location) {
				// Customize the image using Image
				Image("parking_icon")
					.resizable()
					.scaledToFit()
					.frame(width: 30, height: 30)
			}
		}
	}
}
