//
//  LocationManager.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/04/06.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: MapView Live Selection
struct MapViewSelection: View {
	@EnvironmentObject var locationManager: LocationManager
	@State private var isResearch = false
	var body: some View {
		ZStack(alignment: .bottomTrailing) {
			MapViewHelper()
				.environmentObject(locationManager)
				.edgesIgnoringSafeArea(.all)
			
			VStack {
				Button {
					locationManager.mapViewFocusChange()
				} label: {
					ZStack {
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.white)
							.frame(width: 40, height: 40)
						Image("location_icon")
							.resizable()
							.scaledToFit()
							.frame(width: 25, height: 25)
							.foregroundColor(.white)
					}
				}
				.padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 10))
			}
		}
	}
}

// MARK: UIKit MapView
struct MapViewHelper: UIViewRepresentable {
	@EnvironmentObject var locationManager: LocationManager
	func makeUIView(context: Context) -> MKMapView {
		return locationManager.mapView
	}
	
	func updateUIView(_ uiView: MKMapView, context: Context) {}
	
}

class LocationManager: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
	// MARK: Properties
	@Published var mapView: MKMapView = .init()
	@Published var manager: CLLocationManager = .init()
	@Published var currentAddress: String = ""
	
	@Published var isChainging: Bool = false // 지도의 움직임 여부를 저장하는 프로퍼티
	
	// MARK: User Location
	@Published var userLocation: CLLocation?
	@Published var currentGeoPoint: CLLocationCoordinate2D?
	@Published var searchGeoPint: CLLocationCoordinate2D?
	@Published var beforeMoveGeoPoint: CLLocationCoordinate2D?
	
	@Published var currentAroundLocationName: String?
	@Published var currentAroundGeoPoint: CLLocationCoordinate2D?
	
	private var span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
	
	override init() {
		super.init()
		self.configurationManager()
	}
	
	// MARK: 사용자의 위치 권한 여부를 묻거나, 현재 위치로 MapView 이동
	func configurationManager() {
		// MARK: Setting Delegates
		manager.delegate = self
		mapView.delegate = self
		
		let status = manager.authorizationStatus
		
		if status == .notDetermined {
			manager.requestAlwaysAuthorization()
		} else if status == .authorizedAlways || status == .authorizedWhenInUse {
			mapView.showsUserLocation = true
			mapView.setUserTrackingMode(.follow, animated: true)
			self.mapViewFocusChange()
		}
	}
	
	// MARK: MapView에서 화면이 이동하면 호출되는 메서드
	func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
		print("mapViewDidChangeVisibleRegion")
		DispatchQueue.main.async {
			self.isChainging = true
		}
	}
	
	// MARK: MapView에서 화면 이동이 종료되면 호출되는 메서드
	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		print("regionDidChangeAnimated")
		let location: CLLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
		convertLocationToAddress(location: location)
		let coordinatesDic = calcMaxMinCoordinate()
		print(coordinatesDic)
		DispatchQueue.main.async {
			self.isChainging = false
		}
	}
	
	// MARK: MapView에서 화면상에 최대최소 위도 경도 계산하는 메서드
	func calcMaxMinCoordinate() -> [String: Double] {
		print("calcMaxMinCoordinate")
		let span = mapView.region.span
		let center = mapView.region.center
		
		let farSouth = CLLocation(latitude: center.latitude - span.latitudeDelta * 0.5, longitude: center.longitude)
		let farNorth = CLLocation(latitude: center.latitude + span.latitudeDelta * 0.5, longitude: center.longitude)
		let farEast = CLLocation(latitude: center.latitude, longitude: center.longitude + span.longitudeDelta * 0.5)
		let farWest = CLLocation(latitude: center.latitude, longitude: center.longitude - span.longitudeDelta * 0.5)
		
		let maximumLatitude = farSouth.coordinate.latitude as Double
		let minimumLatitude = farNorth.coordinate.latitude as Double
		let maximumLongitude = farWest.coordinate.longitude as Double
		let minimumLongtitude = farEast.coordinate.longitude as Double
		
//		DispatchQueue.main.async {
//			self.maximumLatitude = farSouth.coordinate.latitude as Double
//			self.minimumLatitude = farNorth.coordinate.latitude as Double
//			self.maximumLongitude = farWest.coordinate.longitude as Double
//			self.minimumLongtitude = farEast.coordinate.longitude as Double
//		}
//		self.maximumLatitude = farSouth.coordinate.latitude as Double
//		self.minimumLatitude = farNorth.coordinate.latitude as Double
//		self.maximumLongitude = farWest.coordinate.longitude as Double
//		self.minimumLongtitude = farEast.coordinate.longitude as Double
		
		let coordinatesDic = [
			"minimumLatitude": minimumLatitude,
			"maximumLatitude": maximumLatitude,
			"minimumLongitude": minimumLongtitude,
			"maximumLongitude": maximumLongitude
		]
		return coordinatesDic
	}
	
	// MARK: 특정 위치로 MapView 이동
	func mapViewFocusChange() {
		print("mapViewFocusChange")
		let region = MKCoordinateRegion(center: self.currentGeoPoint ?? CLLocationCoordinate2D(latitude: 37.45174676480123, longitude: 129.16242146005413), span: self.span)
		mapView.setRegion(region, animated: true)
	}
	
	// MARK: 검색한 위치로 MapView 이동
	func searchPointMapViewFocusChange(_ latitude: Double, _ longitude: Double) {
		print("searchPointMapViewFocusChange")
		print(latitude)
		print(longitude)
		let searchGeoPoint = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		let region = MKCoordinateRegion(center: searchGeoPoint, span: self.span)
		mapView.setRegion(region, animated: true)
	}
	
	// MARK: 사용자의 위치 권한이 변경되면 호출되는 메서드 (LocationManager 인스턴스가 생성될 때도 호출)
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		print("locationManagerDidChangeAuthorization")
		if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
			guard let location = manager.location else {
				print("ERROR :: No Location")
				return
			}
			self.currentGeoPoint = location.coordinate
		}
	}
	
	// MARK: 사용자의 위치가 변경되면 호출되는 메서드
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("didUpdateLocations : \(locations)")
	}
	
	// MARK: 사용자의 위치를 가져오지 못하면 호출되는 메서드
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}
	
	// MARK: 현재 위치를 주소로 바꿔주는 메서드
	func convertLocationToAddress(location: CLLocation) {
		let geoCoder = CLGeocoder()
		
		geoCoder.reverseGeocodeLocation(location) { placemarks, error in
			if error != nil {
				return
			}
			guard let placemark = placemarks?.first else { return }
			self.currentAddress = "\(placemark.locality ?? "") \(placemark.subLocality ?? "")"
		}
	}
	// MARK: 검색한 위치에 Pin 꽂아주기
	func addPin(_ placeName: String, _ latitude: Double, _ longitude: Double) {
		let currentPin = MKPointAnnotation()
		currentPin.title = currentAroundLocationName
		currentPin.coordinate = CLLocationCoordinate2D(latitude: currentAroundGeoPoint?.latitude ?? 0.0, longitude: currentAroundGeoPoint?.longitude ?? 0.0)
		mapView.removeAnnotation(currentPin)
		
		print("addPin")
		let pin = MKPointAnnotation()
		pin.title = placeName
		pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		self.currentAroundGeoPoint = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		self.currentAroundLocationName = placeName
		mapView.addAnnotation(pin)
	}
	
	// MARK: Custom Annotation
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			return nil
		}
		
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
		
		if annotationView == nil {
			annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
		} else {
			annotationView?.annotation = annotation
		}
		
		let image = UIImage(named: "point_icon")
		let scaledImageSize = CGSize(width: 40, height: 40)
		
		let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
		let scaledImage = renderer.image { _ in
			image?.draw(in: CGRect(origin: .zero, size: scaledImageSize))
		}
		annotationView?.image = scaledImage
		
		return annotationView
	}
}

extension UIImage {
	func resized(to size: CGSize) -> UIImage {
		return UIGraphicsImageRenderer(size: size).image { _ in
			draw(in: CGRect(origin: .zero, size: size))
		}
	}
}

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
		return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
