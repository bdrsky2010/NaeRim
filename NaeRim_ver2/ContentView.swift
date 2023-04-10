//
//  ContentView.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/03/22.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
	@StateObject private var network = RequestAPI.shared
	
	@State var showDetails = false
	var body: some View {
//		KakaoMapView()
//		SearchTest()
//		TestView2()
		CustomTabView()
//		ScrollView {
//			Toggle(isOn: $showDetails) {
//				Text("Fetch Data")
//			}
//			.onChange(of: showDetails) { value in
//				network.fetchData()
//			}
//			if showDetails {
//				Text("\(network.lots[0].response.body.items)" as String)
//			}
//			Text("hello")
//				.onAppear {
//					network.fetchData()
//				}
			//Text("\(network.lots)" as String)
//		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
