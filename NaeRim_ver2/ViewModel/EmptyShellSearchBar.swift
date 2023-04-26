//
//  EmptyShellSearchBar.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/04/13.
//

import SwiftUI

struct EmptyShellSearchBar: View {
	@Binding var currentAddress: String
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10.0)
				.frame(width: 350, height: 50)
				.foregroundColor(.white)
				.shadow(radius: 5)
			HStack {
				Image(systemName: "magnifyingglass")
					.foregroundColor(.blue)
				Text(currentAddress)
					.frame(width: 200, alignment: .leading)
					.foregroundColor(.secondary)
						.padding(.init(top: 0, leading: 0, bottom: 0, trailing: 100))
			}
		}
	}
}
