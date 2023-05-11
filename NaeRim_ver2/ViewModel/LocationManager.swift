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
	
	@Published var isPressParkingInfo: Bool = false // 주변 주차장 Pin을 탭해서 버튼을 눌렀는 지 유무를 저장하는 프로퍼티
	@Published var popupPrkNm: String = ""
	@Published var popupLatitude: Double = 0.0
	@Published var popupLongitude: Double = 0.0
	
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
	
	// MARK: 검색한 위치에 Pin 출력 메서드
	func addPin(_ placeName: String, _ latitude: Double, _ longitude: Double) {
		print("addPin")
		let pin = MKPointAnnotation()
		pin.title = placeName
		pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		pin.subtitle = "장소검색"
		self.currentAroundGeoPoint = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		self.currentAroundLocationName = placeName
		mapView.removeAnnotations(mapView.annotations.filter { item in
			item.subtitle == "장소검색"
		})
		mapView.addAnnotation(pin)
	}
	
	// MARK: 주변 주차장 위치에 Pin 출력 메서드
	func parkingLotAddPin(_ placeName: String, _ latitude: Double, _ longitude: Double) {
		print("addPin")
		let pin = MKPointAnnotation()
		pin.title = placeName
		pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		pin.subtitle = "주변주차장"
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
		annotationView?.isEnabled = true
		annotationView?.canShowCallout = true
		if annotation.subtitle == "주변주차장" {
			annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
		}
		
		if annotation.subtitle == "주변주차장" {
			let image = UIImage(named: "parking_icon")
			let scaledImageSize = CGSize(width: 40, height: 40)
			
			let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
			let scaledImage = renderer.image { _ in
				image?.draw(in: CGRect(origin: .zero, size: scaledImageSize))
			}
			annotationView?.image = scaledImage
			
		} else if annotation.subtitle == "장소검색" {
			let image = UIImage(named: "point_icon")
			let scaledImageSize = CGSize(width: 40, height: 40)
			
			let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
			let scaledImage = renderer.image { _ in
				image?.draw(in: CGRect(origin: .zero, size: scaledImageSize))
			}
			annotationView?.image = scaledImage
		} else if annotation.subtitle == "출발" {
			let image = UIImage(named: "route_b")
			let scaledImageSize = CGSize(width: 40, height: 40)
			
			let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
			let scaledImage = renderer.image { _ in
				image?.draw(in: CGRect(origin: .zero, size: scaledImageSize))
			}
			annotationView?.image = scaledImage
		} else if annotation.subtitle == "도착" {
			let image = UIImage(named: "route_r")
			let scaledImageSize = CGSize(width: 40, height: 40)
			
			let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
			let scaledImage = renderer.image { _ in
				image?.draw(in: CGRect(origin: .zero, size: scaledImageSize))
			}
			annotationView?.image = scaledImage
		}
		
		return annotationView
	}
	
	// MARK: Pin 탭 후 버튼을 탭 했을 때 호출되는 메서드
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		isPressParkingInfo = true
		popupPrkNm = (view.annotation?.title ?? "")!
		popupLatitude = view.annotation?.coordinate.latitude ?? 0.0
		popupLongitude = view.annotation?.coordinate.longitude ?? 0.0
		print(popupPrkNm)
		print(popupLatitude)
		print(popupLongitude)
	}
	
	// MARK: 내 위치와 선택한 주차장에 대한 경로 출력
	func showRoute(_ destinationLatitude: Double, _ destinationLongitude: Double) {
		let sourcePlacemark = MKPlacemark(coordinate: currentGeoPoint ?? CLLocationCoordinate2D(latitude: 37.45174676480123, longitude: 129.16242146005413), addressDictionary: nil)
		let destinationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude), addressDictionary: nil)
		
		let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
		let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
		
		let sourceAnnotation = MKPointAnnotation()
		
		if let location = sourcePlacemark.location {
			sourceAnnotation.coordinate = location.coordinate
			sourceAnnotation.subtitle = "출발"
		}
		
		let destinationAnnotation = MKPointAnnotation()
		
		if let location = destinationPlacemark.location {
			destinationAnnotation.coordinate = location.coordinate
			destinationAnnotation.subtitle = "도착"
		}
		mapView.addAnnotations([sourceAnnotation, destinationAnnotation])
		
		let directionRequest = MKDirections.Request()
		directionRequest.source = sourceMapItem
		directionRequest.destination = destinationMapItem
		directionRequest.transportType = .automobile
		
		// Calculate the direction
		let directions = MKDirections(request: directionRequest)
		
		directions.calculate {
			(response, error) -> Void in
			
			guard let response = response else {
				if let error = error {
					print("Error: \(error)")
				}
				
				return
			}
			let route = response.routes[0]
			self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
			let rect = route.polyline.boundingMapRect
			self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
		}
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		
		let renderer = MKPolylineRenderer(overlay: overlay)
		
		renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
		
		renderer.lineWidth = 5.0
		
		return renderer
	}
}

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
	return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
