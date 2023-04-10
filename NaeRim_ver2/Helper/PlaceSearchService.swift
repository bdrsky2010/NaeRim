//
//  LocalSearchService.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/03/30.
//

import SwiftUI
import Combine
import MapKit

final class PlaceSearchService {
	let localSearchPublisher = PassthroughSubject<[MKMapItem], Never>()
	private let center: CLLocationCoordinate2D
	private let radius: CLLocationDistance
	
	init(in center: CLLocationCoordinate2D,
			 radius: CLLocationDistance = 100) {
		self.center = center
		self.radius = radius
	}
	
	public func searchPlace(searchText: String) {
		request(resultType: .address, searchText: searchText)
	}
	
	public func searchPointOfInterests(searchText: String) {
		request(searchText: searchText)
	}
	
	private func request(resultType: MKLocalSearch.ResultType = .pointOfInterest, searchText: String) {
		let request = MKLocalSearch.Request()
		request.naturalLanguageQuery = searchText
		request.pointOfInterestFilter = .includingAll
		request.resultTypes = resultType
		request.region = MKCoordinateRegion(center: center,
																				latitudinalMeters: radius,
																				longitudinalMeters: radius)
		
		let search = MKLocalSearch(request: request)
		search.start { response, err in
			guard let response = response else {
				//print(err?.localizedDescription ?? "Unknown Error")
				return
				
			}
			self.localSearchPublisher.send(response.mapItems)
		}
	}
}

struct LocalSearchViewData: Identifiable {
	var id = UUID()
	var title: String
	var subtitle: String
	
	init(mapItem: MKMapItem) {
		self.title = mapItem.name ?? ""
		self.subtitle = mapItem.placemark.title ?? ""
	}
}

final class ContentViewModel: ObservableObject {
	private var cancellable: AnyCancellable?
	
	@Published var cityText = "" {
		didSet {
			searchForCity(text: cityText)
		}
	}
	
	@Published var poiText = "" {
		didSet {
			searchForPOI(text: poiText)
		}
	}
	
	@Published var viewData = [LocalSearchViewData]()
	
	var service: PlaceSearchService
	
	init() {
		//        seoul
		let center = CLLocationCoordinate2D(latitude: 37.27538, longitude: 127.05488)
		service = PlaceSearchService(in: center)
		
		cancellable = service.localSearchPublisher.sink { mapItems in
			self.viewData = mapItems.map({ LocalSearchViewData(mapItem: $0) })
		}
	}
	
	private func searchForCity(text: String) {
		service.searchPlace(searchText: text)
	}
	
	private func searchForPOI(text: String) {
		service.searchPointOfInterests(searchText: text)
	}
}

struct TestView2: View {
	@StateObject private var viewModel = ContentViewModel()
	
	var body: some View {
		VStack(alignment: .leading) {
			TextField("Enter City", text: $viewModel.cityText)
			Divider()
			TextField("Enter Point of interest name", text: $viewModel.poiText)
			Divider()
			Text("Results")
				.font(.title)
			List(viewModel.viewData) { item in
				VStack(alignment: .leading) {
					Text(item.title)
					Text(item.subtitle)
						.foregroundColor(.secondary)
						.font(.system(size: 12))
				}
			}
		}
		.padding(.horizontal)
		.padding(.top)
		.ignoresSafeArea(edges: .bottom)
	}
}

struct TestView2_Previews: PreviewProvider {
	static var previews: some View {
		TestView2()
	}
}
