//
//  JoinGroupViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 20.12.2020.
//

import Foundation

class JoinGroupViewModel: ObservableObject{
    init(service: ConectService? = nil){
        self.service = service
    }
    let service: ConectService?
    @Published var id = ""
    @Published var name = ""
    func joinGroup(){
        if id != "", name != ""  {
            service?.joinGroup(groupID: id, userName: name)
        }
    }
    func createGroupViewModel() -> CreateGroupViewModel {
        CreateGroupViewModel(service: service)
    }
}
