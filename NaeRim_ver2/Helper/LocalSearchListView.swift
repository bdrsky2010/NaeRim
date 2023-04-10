//
//  LocalSearchListView.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/04/08.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import Combine

//struct SearchResult: Codable {
//	let documents: [KLDocument]
//}

class KeyWordSearch: ObservableObject {
	@Published var searchResults: [KLDocument] = []
	
	@Published var query = "" {
		didSet {
			print("set")
			search()
		}
	}
	
	func search() {
		let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
		let headers: HTTPHeaders = [
			"Authorization": "KakaoAK 38a794720ef2cf11b02aef17edbcf1f1"
		]
		var parameters: [String: Any] = [
			"query": query,
			"x": 126.97806,
			"y": 37.56667,
			"sort": "distance"
		]
		AF.request(url, method: .get, parameters: parameters , headers: headers).responseJSON(completionHandler: { response in
			switch response.result {
			case .success(let value):
				print("성공")
				if let detailsPlace = JSON(value)["documents"].array{
					for item in detailsPlace {
						let placeName = item["place_name"].string ?? ""
						let addressName = item["address_name"].string ?? ""
						let roadAddressName = item["road_address_name"].string ?? ""
						let x = item["x"].string ?? ""
						let y = item["y"].string ?? ""
						let distance = item["distance"].string ?? ""
						self.searchResults.append(
							KLDocument(placeName: placeName, addressName: addressName, roadAddressName: roadAddressName, x: x, y: y, distance: distance)
						)
					}
				}
			case .failure(let error):
				print(error.localizedDescription)
			}
		})
	}
}

struct LocalSearchListView: View {
	@State private var searchText = ""
	@ObservedObject var search = KeyWordSearch()
	
	var body: some View {
		VStack {
			TextField("Search", text: $searchText)
				.padding()
			
			List(search.searchResults, id: \.self) { result in
				VStack(alignment: .leading) {
					Text(result.placeName)
					HStack {
						Text(result.addressName)
							.font(.caption)
							.foregroundColor(.gray)
						Spacer()
						let distance = Double(result.distance)
						Text("\(String(format: "%.2f", (distance ?? 0.0)/1000)) Km")
							.font(.caption2)
							.foregroundColor(.gray)
					}
				}
			}
		}
		.onChange(of: searchText) { newValue in
			search.query = newValue
			search.searchResults.removeAll()
		}
	}
}

struct LocalSearchListView_Previews: PreviewProvider {
	static var previews: some View {
		LocalSearchListView()
	}
}
