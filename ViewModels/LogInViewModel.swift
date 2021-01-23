//
//  LogInViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 19.12.2020.
//

import Foundation

class LogInViewModel: ObservableObject{
    init(service: ConectService? = nil){
        self.service = service
    }
    let service: ConectService?
    @Published var visible = false
    @Published var email = ""
    @Published var password = ""
    func logIn(){
        if password != "" && email != "" {
            service?.logIn(with: email, password: password)
        }
    }
    func sgnInViewModel() -> SignInViewModel {
        SignInViewModel(service: service)
    }
}
