//
//  SearchBar.swift
//  NaeRim
//
//  Created by Minjae Kim on 2023/03/18.
//

import SwiftUI

struct SearchBar: View {
	@Binding var text: String
	@Binding var isSearchList: Bool
	var body: some View {
		HStack {
			Button {
				isSearchList.toggle()
			} label: {
				Image("leftArrow_icon")
					.resizable()
					.scaledToFit()
					.frame(width: 20, height: 20)
					.foregroundColor(.blue)
			}
			
			TextField("장소 검색", text: $text)
				.frame(height: 40)
				.foregroundColor(.primary)
				.keyboardType(.default)
				.textInputAutocapitalization(.never)
			if !text.isEmpty {
				Button(action: {
					self.text = ""
				}) {
					Image(systemName: "xmark.circle.fill")
				}
			} else {
				EmptyView()
			}
		}
		.padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
		.background(Color(.white))
		.cornerRadius(10.0)
		.shadow(radius: 5)
	}
}
