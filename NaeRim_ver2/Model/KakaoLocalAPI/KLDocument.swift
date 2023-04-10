//
//  KLDocument.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/04/07.
//

import Foundation

struct KLDocument: Codable, Identifiable, Hashable {
	let id = UUID()
	let placeName: String
	let addressName: String
	let roadAddressName: String
	let x: String
	let y: String
	let distance: String
	
	enum CodingKeys: String, CodingKey {
		case x, y, distance
		case placeName = "place_name"
		case addressName = "address_name"
		case roadAddressName = "road_address_name"
	}
}
