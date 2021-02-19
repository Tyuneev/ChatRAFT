//
//  AuthenticationService.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 07.02.2021.
//

import Foundation
import Combine
import Firebase

class AuthenticationService: AuthenticationServiceProtocol {
    private var stateService: ServiceStatePotocol
    
    init(statusService: ServiceStatePotocol) {
        self.stateService = statusService
        self.checkAuthentification()
    }
    
    private func checkAuthentification() {
        if let id = Auth.auth().currentUser?.uid {
            self.stateService.serviceState = .checkUserGroup(userID: id)
        } else {
            self.stateService.serviceState = .notLogin
        }
    }
    
    func logIn(with email: String, password: String, comlition: @escaping (Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (res, error) in
            guard let result = res,
                  error == nil else {
                comlition(error ?? "Ошибка авторизации")
                return
            }
            self.stateService.serviceState = .checkUserGroup(userID: result.user.uid)
        }
    }
    
    func createUser(with email: String, password: String, comlition: @escaping (Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let result = result {
                self.stateService.serviceState = .login(userID: result.user.uid)
                comlition(nil)
            } else {
                comlition(error ?? " ошибка создания пользователя")
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.stateService.serviceState = .notLogin
        } catch {
            print("ошибка выхода")
            return
        }
    }
}
