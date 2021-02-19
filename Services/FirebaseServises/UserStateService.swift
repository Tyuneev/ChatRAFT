//
//  UserStateService.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 07.02.2021.
//

import Foundation
import Combine

enum ServiceState {
    case checkAuthentification
    case checkUserGroup(userID: String)
    case notLogin
    case login(userID: String)
    case inGroup(groupID: String, userID: String)
}


class StateService: UserStatePotocol, ServiceStatePotocol {
    private let userStateSubject = CurrentValueSubject<UserState, Never>(.loading)
    private let serviceStateSubject = CurrentValueSubject<ServiceState, Never>(.checkAuthentification)
    var userState: UserState {
        get {
            userStateSubject.value
        }
        set {
            if userStateSubject.value != newValue {
                userStateSubject.send(newValue)
            }
        }
    }
    var serviceState: ServiceState {
        get {
            self.serviceStateSubject.value
        }
        set {
            serviceStateSubject.send(newValue)
            switch newValue {
            case .notLogin:
                userState = .notLogin
            case .login:
                userState = .login
            case .inGroup:
                userState = .inGroup
            default:
                return
            }
        }
    }
    func serviceStatePublisher() -> AnyPublisher<ServiceState, Never> {
        self.serviceStateSubject.eraseToAnyPublisher()
    }
    func userStatusPublisher() -> AnyPublisher<UserState, Never> {
        userStateSubject.eraseToAnyPublisher()
    }
}
