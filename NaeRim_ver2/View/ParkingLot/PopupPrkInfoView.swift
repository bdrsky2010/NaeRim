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
	@Binding var isShow: Bool
	@Binding var isShowRoute: Bool
	
	var body: some View {
		VStack{
			PopupMap(prkName: $prkName, latitude: $latitude, longitude: $longitude)
			.frame(width: 350, height: 200)
			Spacer()
			ScrollView {
				VStack {
					Button {
						isShowRoute = true
					} label: {
						ZStack {
							RoundedRectangle(cornerRadius: 10.0)
								.frame(width: 70, height: 30)
							Text("길찾기")
								.foregroundColor(.white)
						}
					}
					Text("\(prkName)")
					Text("\(latitude)")
					Text("\(longitude)")
				}
			}
		}
		.frame(width: 350, height: 600)
		.background(Color.white)
		.cornerRadius(10.0)
		.shadow(radius: 10)
		.onAppear {
			
		}
	}
}
