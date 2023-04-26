//
//  CustomTabView.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/03/27.
//

import SwiftUI
import CoreLocation

struct CustomTabView: View {
	@State private var selectedIndex = 0
	@State private var isShowAround = false
	@State private var isFavorite = false
	@State private var isSearchList = false
	
	@State private var aroundLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
	@State private var aroundLocationName: String = ""
	
	let tabbarImageName = ["map.fill", "bookmark.fill", "gearshape.fill"]
	let tabbarName = ["주변", "즐겨찾기", "설정"]
	var body: some View {
		NavigationView {
			ZStack {
				MainMapView(aroundLocationName: $aroundLocationName, aroundLocationCoordinate: $aroundLocationCoordinate)
					.padding(.bottom, 50)
				VStack {
					Spacer()
					HStack {
						Spacer()
						ForEach(0..<tabbarImageName.count-1, id:\.self) { num in
							VStack {
								Image(systemName: tabbarImageName[num])
									.font(.system(size: 20, weight: .bold))
									.foregroundColor(selectedIndex == num ? Color(.systemBlue) : Color(.tertiaryLabel))
								
								Text(tabbarName[num])
									.font(.system(size: 12, weight: .bold))
									.foregroundColor(selectedIndex == num ? Color(.systemBlue) : Color(.tertiaryLabel))
							}
							.gesture(
								TapGesture()
									.onEnded { _ in
										selectedIndex = num
										if self.selectedIndex == 0 {
											self.isShowAround = true
										}
										else if self.selectedIndex == 1 {
											self.isFavorite = true
										}
									}
							)
							Spacer()
						}
//						NavigationLink(destination: Text("Detail View")) {
//							VStack {
//								Image(systemName: tabbarImageName[2])
//									.font(.system(size: 20, weight: .bold))
//									.foregroundColor(selectedIndex == 2 ? Color(.systemBlue) : Color(.tertiaryLabel))
//								Text(tabbarName[2])
//									.font(.system(size: 12, weight: .bold))
//									.foregroundColor(selectedIndex == 2 ? Color(.systemBlue) : Color(.tertiaryLabel))
//							}
//						}
//						Spacer()
					}
					.padding(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
					.background(Color.white)
				}
				
				// MARK: 주변 주차장 뷰
				.sheet(isPresented: $isShowAround) {
					ListView(isShow: $isShowAround, aroundLocationName: $aroundLocationName, aroundLocationCoordinate: $aroundLocationCoordinate)
					.presentationDetents([.medium, .large])
					.presentationDragIndicator(.visible)
				}
				// MARK: 즐겨찾기 주차장 뷰
				.sheet(isPresented: $isFavorite) {
					ListView2(isShow: $isFavorite)
						.presentationDetents([.medium, .large])
						.presentationDragIndicator(.visible)
				}
			}
		}
	}
}
struct CustomTabView_Previews: PreviewProvider {
	static var previews: some View {
		CustomTabView()
	}
}
