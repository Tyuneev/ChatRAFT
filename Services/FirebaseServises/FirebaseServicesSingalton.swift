//
//  Services.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 11.02.2021.
//

import Foundation
import Firebase

final class FirebaseServices {
    static let shered = FirebaseServices()
    init() {
        self.userStateService = StateService()
        FirebaseApp.configure()
        self.authenticationService = AuthenticationService(statusService: self.userStateService)
        self.groupService = GroupService(statusService: self.userStateService)
        self.locationService = LocationService(geopositionService: groupService.geopositionSharing)
        locationService.requestPermission()
        locationService.start()
    }
    private let locationService: LocationService
    private let userStateService: StateService
    private let authenticationService: AuthenticationService
    private let groupService: GroupService
    var userState: UserStatePotocol {
        return self.userStateService
    }
    var authentication: AuthenticationServiceProtocol {
        return self.authenticationService
    }
    var group: GroupServiceProtocol {
        return self.groupService
    }
}
