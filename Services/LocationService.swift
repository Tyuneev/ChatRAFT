//
//  LocationService.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 23.12.2020.
//

import Foundation

import CoreLocation
import CoreMotion

final class LocationService: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private let motionManager = CMMotionActivityManager()
    private var geopositionService: GeopositionSheringServiceProtocol
    init(geopositionService: GeopositionSheringServiceProtocol) {
        self.geopositionService = geopositionService
        super.init()
        configurate()
    }
    
    
    private func configurate() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
 //       locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func requestPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func start() {
        setActiveMode(true)
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        motionManager.startActivityUpdates(to: .main, withHandler: { [weak self] activity in
            self?.setActiveMode(activity?.cycling ?? false)
        })
    }
    
    private func setActiveMode(_ value: Bool) {
        if value {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 10
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.distanceFilter = CLLocationDistanceMax
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else {
            return
        }
        geopositionService.sendGeoposition(Geoposition(latitude: coordinate.latitude, longitude: coordinate.longitude, timeStamp: Date(), sender: .user)) { _ in

        }
    
    }
}
