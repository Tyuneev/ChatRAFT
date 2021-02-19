//
//  SettingsViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 16.12.2020.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    init() {
        self.authenticationService = FirebaseServices.shered.authentication
        self.groupService = FirebaseServices.shered.group
        self.name = groupService.userInfo()?.name ?? ""
    }
    @Published var name = ""
    @Published var editField = false
    var groupID: String {
        groupService.groupInfo()?.id ?? ""
    }
    let authenticationService: AuthenticationServiceProtocol
    let groupService: GroupServiceProtocol
    
    func leftGroup() {
        groupService.leaveGroup() { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func logOut() {
        authenticationService.logOut()
    }
    func chageName() {
        if self.name != "" {
            groupService.changeUserInfo(Member(id: "", name: name)) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        self.editField = false
    }
    //func chageFontSize(on sise: Double){}
    //func chageAccentColor(on sise: Double){}
}
