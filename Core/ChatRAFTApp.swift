//
//  ChatRAFTApp.swift
//  Shared
//
//  Created by Алексей Тюнеев on 07.12.2020.
//

import SwiftUI
import Firebase

@main
struct ChatRAFTApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var deligate
    let appModel = Model(service: FirebaseService())
    var body: some Scene {
        WindowGroup {
            HomeView(model: HomeViewModel(model: appModel))
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    private let locationService = LocationService()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        locationService.requestPermission()
        locationService.start()
        return true
    }
}


