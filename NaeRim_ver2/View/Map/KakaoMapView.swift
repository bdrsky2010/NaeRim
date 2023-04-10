//
//  KakaoMapView.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/04/08.
//

import SwiftUI

struct KakaoMapView: UIViewControllerRepresentable {
	func makeUIViewController(context: Context) -> some UIViewController {
		return KakaoMapVC()
	}
	
	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
		
	}
}

class KakaoMapVC: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		let mapView = MTMapView(frame: self.view.frame)
		mapView.baseMapType = .standard
		self.view.addSubview(mapView)
	}
}
