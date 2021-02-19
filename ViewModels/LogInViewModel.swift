//
//  LogInViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 19.12.2020.
//

import Foundation

class LogInViewModel: ObservableObject{
    init() {
        service = FirebaseServices.shered.authentication
    }
    let service: AuthenticationServiceProtocol
    @Published var visible = false
    @Published var email = ""
    @Published var password = ""
    @Published var loading = false
    @Published var alertIsPresented = false
    var alertText = ""
    func logIn() {
        if password == "" ||  email == "" {
            alertText  = "Заполните поля"
            alertIsPresented  = true
        }  else {
            loading = true
            service.logIn(with: email, password: password) { [weak self] error in
                if let error = error {
                    self?.loading = false
                    self?.alertText  = error.localizedDescription
                    self?.alertIsPresented  = true
                } else {
                    
                }
            }
        }
    }
}
