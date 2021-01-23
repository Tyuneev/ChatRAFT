//
//  CreateGroupViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 20.12.2020.
//

import Foundation

class CreateGroupViewModel: ObservableObject{
    init(service: ConectService? = nil){
        self.service = service
    }
    let service: ConectService?
    @Published var name = ""
    func createGroup(){
        if name != "" {
            service?.createGroup(userName: name)
        }
    }
}
