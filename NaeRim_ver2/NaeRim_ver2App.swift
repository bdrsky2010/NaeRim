//
//  NaeRim_ver2App.swift
//  NaeRim_ver2
//
//  Created by Minjae Kim on 2023/03/22.
//

import SwiftUI
import Foundation
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
	func application(_ application: UIApplication,
									 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()
		
		return true
	}
}


@main
struct NaeRim_ver2App: App {
	// register app delegate for Firebase setup
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	
	var body: some Scene {
		WindowGroup {
			ContentView()
		}
	}
}
