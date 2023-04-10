//
//  MapView.swift
//  Landmarks
//
//  Created by Minjae Kim on 2023/03/07.
//

import SwiftUI
import MapKit

struct ParkingLocation: Codable, Identifiable {
	var id = UUID()
	var prkName: String
	var latitude, longitude: Double
	//Computed Property
	var location: CLLocationCoordinate2D {
		CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}
}

struct MapView: View {
	var coordinate: CLLocationCoordinate2D
	let locationManager = CLLocationManager()
	@State private var region = MKCoordinateRegion()
	@State var tracking: MapUserTrackingMode = .follow
	
	@State private var isPresent = false
	@State private var prkName = ""
	@State private var latitude = 0.0
	@State private var longitude = 0.0
	
	let locations: [ParkingLocation] = [
		ParkingLocation.init(prkName: "제 1주차장",latitude: 37.5666805, longitude: 126.9784147),
		ParkingLocation.init(prkName: "제 2주차장", latitude: 37.567867, longitude: 126.9784147),
		ParkingLocation.init(prkName: "강원대학교 그린에너지관 주차장", latitude: 37.45174676480123, longitude: 129.16242146005413)
	]
	
	var body: some View {
		Map(coordinateRegion: $region, showsUserLocation: true,
				userTrackingMode: $tracking, annotationItems: locations) { item in
			MapAnnotation(coordinate: item.location) {
				Button {
					self.prkName = item.prkName
					self.latitude = item.latitude
					self.longitude = item.longitude
					self.isPresent.toggle()
					print("Location is", item.location)
				} label: {
					VStack {
						ZStack {
							Image("parking_pin_g")
								.resizable()
								.scaledToFit()
								.frame(width: 70, height: 70)
							Text("50")
								.padding(.bottom)
								.font(.system(size: 17.5))
								.foregroundColor(.white)
								.fontWeight(.heavy)
						}
						Text(item.prkName)
							.font(.system(size: 17.5).bold())
							.foregroundColor(.black)
					}
				}
			}
		}
				.onAppear {
					setRegion(coordinate)
				}
				.edgesIgnoringSafeArea(.all)
				.sheet(isPresented: $isPresent) {
					VStack {
						Button {
							self.isPresent = false
						} label: {
							Image(systemName: "xmark")
								.foregroundColor(.black)
						}
						.padding(.init(top: 50, leading: 0, bottom: 10, trailing: 300))
						Spacer()
						VStack {
							ParkingLotInfoView(prkName: self.$prkName, latitude: self.$latitude, longitude: self.$longitude)
						}
						.padding(.init(top: 0, leading: 0, bottom: 200, trailing: 0))
					}
						.presentationDetents([.medium, .large])
						.presentationDragIndicator(.visible)
						.onAppear {
							print(self.prkName)
							print("위도 : \(self.latitude)")
							print("경도 : \(self.longitude)")
						}
				}
				.transition(AnyTransition.opacity.animation(.default))
	}
	
	private func setRegion(_ coordinate: CLLocationCoordinate2D) {
		region = MKCoordinateRegion (
			center: coordinate,
			span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
		)
	}
	
	private func configureLocationManager() {
		
	}
}

struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		MapView(coordinate: CLLocationCoordinate2D(latitude: 37.5666805, longitude: 126.9784147))
	}
}
