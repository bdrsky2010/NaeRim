//
//  RequestApi.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/03/24.
//

import Foundation
import Combine
import SwiftUI

// MARK: - Welcome
struct Welcome: Codable {
	let response: Response
}

// MARK: - Response
struct Response: Codable {
	let header: Header
	let body: Body
}

// MARK: - Body
struct Body: Codable {
	var items: [Item]
}

// MARK: - Item
struct Item: Codable, Hashable {
	let prkplceNo, prkplceNm, prkplceSE, prkplceType: String
	let rdnmadr, lnmadr, prkcmprt, feedingSE: String
	let enforceSE, operDay, weekdayOperOpenHhmm, weekdayOperColseHhmm: String
	let satOperOperOpenHhmm, satOperCloseHhmm, holidayOperOpenHhmm, holidayCloseOpenHhmm: String
	let parkingchrgeInfo, basicTime, basicCharge, addUnitTime: String
	let addUnitCharge, dayCmmtktAdjTime, dayCmmtkt, monthCmmtkt: String
	let metpay, spcmnt, institutionNm, phoneNumber: String
	let latitude, longitude, referenceDate, insttCode: String
	
	enum CodingKeys: String, CodingKey {
		case prkplceNo, prkplceNm
		case prkplceSE = "prkplceSe"
		case prkplceType, rdnmadr, lnmadr, prkcmprt
		case feedingSE = "feedingSe"
		case enforceSE = "enforceSe"
		case operDay, weekdayOperOpenHhmm, weekdayOperColseHhmm, satOperOperOpenHhmm, satOperCloseHhmm, holidayOperOpenHhmm, holidayCloseOpenHhmm, parkingchrgeInfo, basicTime, basicCharge, addUnitTime, addUnitCharge, dayCmmtktAdjTime, dayCmmtkt, monthCmmtkt, metpay, spcmnt, institutionNm, phoneNumber, latitude, longitude, referenceDate, insttCode
	}
}

// MARK: - Header
struct Header: Codable {
	let resultCode, resultMsg, type: String
}

class RequestAPI: ObservableObject {
	static let shared = RequestAPI()
	@Published var lots = [Welcome]()
	public init() {}
	
	private let apiKey = Bundle.main.object(forInfoDictionaryKey: "%2BtajPn8EjBDkSUbPdy2yWMDYMbO9CS9y8KUR6ER0PHxt9svwFObOdK5K8B2r56I0N8AheqzbCAixyIzLySIBAg%3D%3D") as? String
	
	func fetchData(){
		
		//guard let apiKey = apiKey else { return }
		
		if let url = URL(string: "http://api.data.go.kr/openapi/tn_pubr_prkplce_info_api?serviceKey=%2BtajPn8EjBDkSUbPdy2yWMDYMbO9CS9y8KUR6ER0PHxt9svwFObOdK5K8B2r56I0N8AheqzbCAixyIzLySIBAg%3D%3D&pageNo=0&numOfRows=100&type=json") {
			URLSession.shared.dataTask(with: url){ data, res, err in
				if let data = data{
					print("hey")
					let decoder = JSONDecoder()
					
					//??
					
					print(String(decoding:data , as : UTF8.self))
					
					//decode is not working mabye
					if let json = try? decoder.decode(Welcome.self, from : data){
//						print("출력이되나??")
//						print(json.response.body.items[10].prkplceNm)
//						print(json.response.body.items[10].longitude)
//						print(json.response.body.items[10].latitude)
//						print(json.response.body.items.count)
						DispatchQueue.main.async {
							self.lots = [json]
						}
						//print(json)
						//print("aa")
					}
				}
				//print(self.lots[0].response.body.items[0].self)
			}.resume()
		}
	}
}
