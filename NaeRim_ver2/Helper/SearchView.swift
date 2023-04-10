//
//  SearchView.swift
//  NaeRim
//
//  Created by Minjae Kim on 2023/03/18.
//

import SwiftUI

struct SearchView: View {
	@State private var isShow = false
	@State private var isAnimating = false
	let arr = [
		"강원대학교 삼척캠퍼스 그린에너지관 주차장", "강원대학교 삼척캠퍼스 5공학관 주차장", "강원대학교 삼척캠퍼스 강의동 주차장", "삼척시 동부아파트 주차장", "삼척시청 주차장", "교동 주민센터 주차장", "잠실올림픽경기장 주차장", "장미공원 주차장", "parking lot"
	]
	@State private var searchText = ""
	var body: some View {
		VStack {
			SearchBar(text: $searchText)
				.frame(width: 380)
				.onTapGesture {
					isShow = true
				}
			if isShow {
				ZStack {
					NavigationView {
						List(arr.filter({"\($0)".contains(self.searchText) || self.searchText.isEmpty}), id : \.self){ i in
							Text("\(i)")
								.navigationBarItems(leading: exitButton)
						}
					}
				}
			}
		}
	}
	
	private var exitButton: some View {
		Button {
			isShow.toggle()
		} label: {
			Image(systemName: "xmark")
				.foregroundColor(.black)
		}
	}
}

struct SearchView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView()
	}
}
