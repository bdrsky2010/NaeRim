//
//  MainMapView.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/04/15.
//

import SwiftUI
import CoreLocation
import ExytePopupView

struct MainMapView: View {
	@State private var isSearchList = false
	@StateObject var locationManager: LocationManager = .init()
	@State private var parkingLotInfo: [Item] = []
	
	// 주변 주차장
	@Binding var aroundLocationName: String
	@Binding var aroundLocationCoordinate: CLLocationCoordinate2D
	@State private var currentAroundLocationName: String = ""
	@State private var currentAroundLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
	
	@State private var isShowRoute: Bool = false
	
	// 즐겨찾기 주차장
	
	// 장소검색 주변 주차장
	@State private var searchLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
	
	// 주차장 API 리스트
	@Binding var lots: [Welcome]
	
	// 지도 중심 위치 변경 시 최대최소 위도, 경도를 담고있는 컬렉션
	@Binding var minMaxCoordinateDic: [String: Double]
	
	var body: some View {
		ZStack {
			MapViewSelection().environmentObject(locationManager)
			// 장소를 검색했을 때 메인 지도를 그 위치로 이동 및 핀 꽂아주기
				.onChange(of: searchLocationCoordinate) { newValue in
					if newValue.latitude != 0.0 && newValue.longitude != 0.0 {
						locationManager.searchPointMapViewFocusChange(newValue.latitude, newValue.longitude)
						locationManager.addPin(aroundLocationName, newValue.latitude, newValue.longitude)
					}
				}
			
			// 지도 중심위치 변경되면 최대 최소 위도 경도 좌표를 변경해줌
				.onChange(of: !locationManager.isChainging) { newValue in
					if newValue {
						locationManager.mapView.removeAnnotations(locationManager.mapView.annotations.filter { item in
							item.subtitle == "주변주차장"
						})
						self.minMaxCoordinateDic = locationManager.calcMaxMinCoordinate()
						
						let filteredItems = lots.flatMap { lot in
							lot.response.body.items.filter { item in
								let itemLatitude = Double(item.latitude) ?? 0.0
								let itemLongitude = Double(item.longitude) ?? 0.0
								return (itemLatitude >= minMaxCoordinateDic["maximumLatitude"] ?? 0.0) && (itemLatitude <= minMaxCoordinateDic["minimumLatitude"] ?? 0.0) &&
								(itemLongitude >= minMaxCoordinateDic["maximumLongitude"] ?? 0.0) && (itemLongitude <= minMaxCoordinateDic["minimumLongitude"] ?? 0.0)
							}
						}
						for i in 0..<filteredItems.count {
							locationManager.parkingLotAddPin(filteredItems[i].prkplceNm, Double(filteredItems[i].latitude)!, Double(filteredItems[i].longitude)!)
						}
					}
				}
				.popup(isPresented: $locationManager.isPressParkingInfo) {
					PopupPrkInfoView(prkName: $locationManager.popupPrkNm, latitude: $locationManager.popupLatitude, longitude: $locationManager.popupLongitude, isShow: $locationManager.isPressParkingInfo, isShowRoute: $isShowRoute)
				} customize: {
					$0.closeOnTapOutside(true).closeOnTap(false)
				}
			
			// 길찾기 뷰
			if isShowRoute {
				ShowRouteMap(isShow: $isShowRoute, destinationLatitude: locationManager.popupLatitude, destinationLogitude: locationManager.popupLongitude)
			}
			
			VStack {
				EmptyShellSearchBar(currentAddress: $locationManager.currentAddress)
					.padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
					.onTapGesture {
						isSearchList = true
					}
				Spacer()
			}
		}
		.fullScreenCover(isPresented: $isSearchList) {
			LocalSearchView(isSearchList: $isSearchList, searchLocationCoordinate: $searchLocationCoordinate)
		}
	}
}

//struct MainMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainMapView()
//    }
//}
