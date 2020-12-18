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
    //let appModel = Model(service: FirebaseService())
    var body: some Scene {
        WindowGroup {
            Home()
            //HomeView(model: HomeViewModel(model: appModel))
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        
        return true
    }
}


