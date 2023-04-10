//
//  SearchBar.swift
//  NaeRim
//
//  Created by Minjae Kim on 2023/03/18.
//

import SwiftUI

struct SearchBar: View {
	@Binding var text: String
	
	var body: some View {
		HStack {
			HStack {
				Image(systemName: "magnifyingglass")
					.foregroundColor(.blue)
				
				TextField("Search", text: $text)
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
			.foregroundColor(.secondary)
			.background(Color(.white))
			.cornerRadius(10.0)
		}
		.padding(.horizontal)
	}
}
