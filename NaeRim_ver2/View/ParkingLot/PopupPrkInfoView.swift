//
//  PopupPrkInfoView.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/03/27.
//

import SwiftUI

struct PopupPrkInfoView: View {
	@Binding var prkName: String
	@Binding var latitude: Double
	@Binding var longitude: Double
	
	var body: some View {
		VStack{
			PopupMap(prkName: $prkName, latitude: $latitude, longitude: $longitude)
			.frame(width: 300, height: 200)
			Spacer()
			Text("\(prkName)")
			Text("\(latitude)")
			Text("\(longitude)")
			Spacer()
		}
		.frame(width: 300, height: 400)
		.background(Color.white)
		.cornerRadius(10.0)
		.shadow(radius: 10)
		.onAppear {
			
		}
	}
}
