//
//  ListView.swift
//  NaeRim
//
//  Created by Minjae Kim on 2023/03/20.
//

import SwiftUI
import ExytePopupView

struct ListView: View {
	@State private var prkName = ""
	@State private var latitude = 0.0
	@State private var longitude = 0.0
	
	@State private var shouldShowPopup = false
	@Binding var isShow: Bool
	
	@State private var locations: [ParkingLocation] = [
		ParkingLocation.init(prkName: "삼척시청주차장",latitude: 37.4496777, longitude: 129.166228),
		ParkingLocation.init(prkName: "삼척시청별관주차장", latitude: 37.4489156, longitude: 129.163076),
		ParkingLocation.init(prkName: "강원대학교 그린에너지관 주차장", latitude: 37.45174676480123, longitude: 129.16242146005413),
		ParkingLocation(prkName: "강원대학교 삼척캠퍼스 제 5공학관 주차장", latitude: 37.452918, longitude: 129.159902),
		ParkingLocation(prkName: "삼척문화예술회관", latitude: 37.438036, longitude: 129.159363)
	]
	
	var body: some View {
		NavigationView {
			List(locations) { loc in
				Text("\(loc.prkName)")
					.onTapGesture {
						prkName = loc.prkName
						latitude = loc.latitude
						longitude = loc.longitude
						shouldShowPopup.toggle()
					}
			}
			.popup(isPresented: $shouldShowPopup) {
				PopupPrkInfoView(prkName: $prkName, latitude: $latitude, longitude: $longitude)
				
			} customize: {
				$0.closeOnTapOutside(true).closeOnTap(false)
			}
			//listStyle을 정해줌
			.listStyle(DefaultListStyle())
			.navigationBarTitle("주변")
			.navigationBarItems(leading: exitButton)
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
