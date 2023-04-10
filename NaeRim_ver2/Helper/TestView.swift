//
//  TestView.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/03/28.
//

import SwiftUI
import CoreLocation

struct TestView: View {
    var body: some View {
			MapView(coordinate: CLLocationCoordinate2D(latitude: 37.45174676480123, longitude: 129.16242146005413))
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
