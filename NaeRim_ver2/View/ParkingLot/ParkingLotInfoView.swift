//
//  ParkingLotInfoView.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/03/27.
//

import SwiftUI

struct ParkingLotInfoView: View {
	@Binding var prkName: String
	@Binding var latitude: Double
	@Binding var longitude: Double
	var body: some View {
		VStack {
			Text("\(prkName)")
			Text("\(latitude)")
			Text("\(longitude)")
		}
	}
}
