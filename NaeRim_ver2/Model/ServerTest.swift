//
//  ServerTest.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/04/03.
//

import SwiftUI
import FirebaseDatabase
import FirebaseDatabaseSwift

struct ServerTest: View {
	var ref: DatabaseReference = Database.database().reference()
	
	var body: some View {
		Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
	}
}

struct ServerTest_Previews: PreviewProvider {
	static var previews: some View {
		ServerTest()
	}
}
