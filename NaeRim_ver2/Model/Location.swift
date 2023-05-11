//
//  Location.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/05/01.
//

import Foundation
import CoreLocation

struct Location: Identifiable, Codable, Equatable {
	var id: UUID
	var name: String
	let latitude: Double
	let longitude: Double
	
	var coordinate: CLLocationCoordinate2D {
		CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}
	
	static func ==(lhs: Location, rhs: Location) -> Bool {
		lhs.id == rhs.id
	}
}
