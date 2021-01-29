//
//  ChatRAFTApp.swift
//  Shared
//
//  Created by Алексей Тюнеев on 07.12.2020.
//

import SwiftUI
import Firebase
import CoreLocation
import CoreMotion

@main
struct ChatRAFTApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var deligate
    let appModel = Model()
    var body: some Scene {
        WindowGroup {
            HomeView(model: HomeViewModel(model: appModel))
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    //var locMod:locationModule?


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        if ( locMod == nil )
//        {
//           locMod = locationModule()
//        }
//        locMod?.getLocation()
        return true
    }
}


class locationModule: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()

    internal func getLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }


    // MARK : CLLocationManagerDelegate protocol
    @objc
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            print("\(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
    }
}

