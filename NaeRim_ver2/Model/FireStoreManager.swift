////
////  FireStoreManager.swift
////  NaeRim_ver2
////
////  Created by Minjae Kim on 2023/04/16.
////
//
//import SwiftUI
//import Combine
//import Firebase
//
//// MARK: - Item
//struct Item: Codable {
//	let items: [ItemElement]
//}
//
//// MARK: - ItemElement
//struct ItemElement: Codable {
//	let prkplceNo, prkplceNm, prkplceSE, prkplceType: String
//	let rdnmadr, lnmadr, prkcmprt, feedingSE: String
//	let enforceSE, operDay, weekdayOperOpenHhmm, weekdayOperColseHhmm: String
//	let satOperOperOpenHhmm, satOperCloseHhmm, holidayOperOpenHhmm, holidayCloseOpenHhmm: String
//	let parkingchrgeInfo, basicTime, basicCharge, addUnitTime: String
//	let addUnitCharge, dayCmmtktAdjTime, dayCmmtkt, monthCmmtkt: String
//	let metpay, spcmnt, institutionNm, phoneNumber: String
//	let latitude, longitude: Double
//	let referenceDate, insttCode: String
//	
//	enum CodingKeys: String, CodingKey {
//		case prkplceNo, prkplceNm
//		case prkplceSE = "prkplceSe"
//		case prkplceType, rdnmadr, lnmadr, prkcmprt
//		case feedingSE = "feedingSe"
//		case enforceSE = "enforceSe"
//		case operDay, weekdayOperOpenHhmm, weekdayOperColseHhmm, satOperOperOpenHhmm, satOperCloseHhmm, holidayOperOpenHhmm, holidayCloseOpenHhmm, parkingchrgeInfo, basicTime, basicCharge, addUnitTime, addUnitCharge, dayCmmtktAdjTime, dayCmmtkt, monthCmmtkt, metpay, spcmnt, institutionNm, phoneNumber, latitude, longitude, referenceDate, insttCode
//	}
//}
//
//class FireStoreManager: ObservableObject {
//	@Published var items = [ItemElement]()
//	
//	init() {
//		let ref = Database.database().reference(withPath: "items")
//		ref.observeSingleEvent(of: .value, with: { snapshot in
//			guard let jsonData = try? JSONSerialization.data(withJSONObject: snapshot.value ?? [:]) else {
//				return
//			}
//			do {
//				let items = try JSONDecoder().decode([ItemElement].self, from: jsonData)
//				DispatchQueue.main.async {
//					self.items = items
//				}
//				print(self.items)
//			} catch {
//				print("Error: \(error.localizedDescription)")
//			}
//		})
//	}
//}
