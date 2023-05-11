//
//  SwiftUIView.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/05/08.
//

import SwiftUI

struct ShowRouteMap: View {
	@StateObject var locationManager: LocationManager = .init()
	@Binding var isShow: Bool
	let destinationLatitude: Double
	let destinationLogitude: Double
	var body: some View {
		ZStack {
			MapViewSelection().environmentObject(locationManager)
				.onAppear {
					locationManager.showRoute(destinationLatitude, destinationLogitude)
				}
			VStack {
				Spacer()
				Button {
					isShow.toggle()
				} label: {
					ZStack {
						RoundedRectangle(cornerRadius: 10.0)
							.frame(width: 70, height: 30)
						Text("취소")
							.foregroundColor(.white)
					}
				}
				.padding()
			}
		}
	}
}
