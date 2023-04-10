//
//  LocalAPI.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/04/08.
//

import Foundation
import Alamofire
import SwiftyJSON
import Combine

class LocalAPI: ObservableObject {
	static let shared = LocalAPI()
	@Published var resultList = [KLDocument]()
	public init() {}
	
	// MARK: Search Bar Test
	@Published var searchText: String = ""
	
	private let headers: HTTPHeaders = [
		"Authorization": "KakaoAK 38a794720ef2cf11b02aef17edbcf1f1"
	]
	func requestData() {
		let parameters: Parameters = [
			"query": searchText,
			"x": 126.97806,
			"y": 37.56667,
			"sort": "distance"
		]
		AF.request("https://dapi.kakao.com/v2/local/search/keyword.json", method: .get,
							 parameters: parameters, headers: headers)
		.responseJSON(completionHandler: { response in
			switch response.result {
			case .success(let value) :
				if let detailsPlace = JSON(value)["documents"].array{
					for item in detailsPlace {
						let placeName = item["place_name"].string ?? ""
						let addressName = item["address_name"].string ?? ""
						let roadAddressName = item["road_address_name"].string ?? ""
						let x = item["x"].string ?? ""
						let y = item["y"].string ?? ""
						let distance = item["distance"].string ?? ""
						self.resultList.append(KLDocument(placeName: placeName, addressName: addressName, roadAddressName: roadAddressName, x: x, y: y, distance: distance))
					}
				}
			case .failure(let error):
				print(error)
			}
		})
	}
}
