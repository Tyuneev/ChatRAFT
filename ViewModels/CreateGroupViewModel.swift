//
//  CreateGroupViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 20.12.2020.
//

import Foundation

class CreateGroupViewModel: ObservableObject{
    init(){
        self.groupService = FirebaseServices.shered.group
    }
    let groupService: GroupServiceProtocol
    @Published var name = ""
    @Published var loading = false
    @Published var alertIsPresented = false
    var alertText = ""
    
    func createGroup(){
        if name != "" {
            loading = true
            groupService.createGroup(userInfo: Member(id: "", name: name)) {  [weak self] error in
                if let error = error {
                    self?.alertText  = error.localizedDescription
                    self?.loading = false
                    self?.alertIsPresented  = true
                } else{
                    
                }
            }
        } else {
            alertText = "Введите имя"
            alertIsPresented = true
        }
    }
}
