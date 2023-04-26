//
//  RefreshBar.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/04/16.
//

import SwiftUI

struct RefreshBarButton: View {
	@Binding var isResearch: Bool
    var body: some View {
			Button {
				isResearch = true
			} label: {
				ZStack(alignment: .center) {
					RoundedRectangle(cornerRadius: 10.0)
						.frame(width: 170, height: 40)
						.foregroundColor(.white)
						.shadow(radius: 5)
					HStack {
						Image("refresh_icon")
							.resizable()
							.scaledToFit()
							.frame(width: 20, height: 20)
						Text("이 지역 주차장 검색")
					}
				}
			}
    }
}
