//
//  SignInViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 20.12.2020.
//

import Foundation

class SignInViewModel: ObservableObject {
    init(service: ConectService? = nil) {
        self.service = service
    }
    let service: ConectService?
    @Published var visible = false
    @Published var email = ""
    @Published var password = ""
    @Published var passwordRepeat = ""
    func createUser() {
        if password != "", self.passwordsSame(), email != "" {
            service?.createUser(with: email, password: password)
        }
    }
    func passwordsSame() -> Bool {
        return  password == passwordRepeat
    }
}
