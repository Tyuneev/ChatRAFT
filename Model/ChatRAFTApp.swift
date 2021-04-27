//
//  ChatRAFTApp.swift
//  Shared
//
//  Created by Алексей Тюнеев on 07.12.2020.
//

import SwiftUI

@main
struct ChatRAFTApp: App {
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var deligate
   // let appModel = Model()
    var body: some Scene {
        WindowGroup {
            HomeView(model: HomeViewModel())
        }
    }
}

//
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        return true
//    }
//}
