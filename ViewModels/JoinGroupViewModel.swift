//
//  JoinGroupViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 20.12.2020.
//

import Foundation

class JoinGroupViewModel: ObservableObject{
    init(){
        self.groupService = FirebaseServices.shered.group
    }
    let groupService: GroupServiceProtocol
    @Published var id = ""
    @Published var name = ""
    @Published var loading = false
    @Published var alertIsPresented = false
    var alertText = ""
    
    func joinGroup(){
        if name == "" {
            alertText = "Введите имя"
            alertIsPresented = true
        } else if id == "" {
            alertText = "Введите id группы"
            alertIsPresented = true
        } else {
            loading = true
            groupService.joinGroup(groupInfo: GroupInfo(id: id), userInfo: Member(id: "", name: name)) {  [weak self] error in
                if let error = error {
                    self?.alertText  = error.localizedDescription
                    self?.loading = false
                    self?.alertIsPresented  = true
                } else {
                    
                }
            }
        }
    }
    
    
}
