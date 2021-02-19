//
//  SignInViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 20.12.2020.
//

import Foundation

class SignInViewModel: ObservableObject {
    init() {
        self.service = FirebaseServices.shered.authentication
    }
    let service: AuthenticationServiceProtocol
    @Published var visible = false
    @Published var email = ""
    @Published var password = ""
    @Published var passwordRepeat = ""
    @Published var loading = false
    @Published var alertIsPresented = false
    var alertText = ""
    
    func createUser() {
        if password == "" || email == "" {
            showAlertWith(messege: "Заполните поля")
        } else if password != passwordRepeat {
            showAlertWith(messege: "Пароли не совпадают")
        } else {
            loading = true
            service.createUser(with: email, password: password) {  [weak self] error in
                if let error = error {
                    self?.showAlertWith(messege: error.localizedDescription)
                }
                self?.loading = false
            }
        }
    }
    func showAlertWith(messege: String) {
        alertText = messege
        alertIsPresented = true
    }

}
