//
//  SettingsViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 16.12.2020.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    init(service: ConectService? = nil, groupID: String = "1234АйДи1234блаблабла", userName: String = "Алексей ") {
        self.service = service
        self.groupID = groupID
        self.name = userName
    }
    @Published var name = ""
    @Published var editField = false
    var groupID: String
    let service: ConectService?
    
    func leftGroup() {
        service?.leaveGroup()
    }
    func logOut() {
        service?.logOut()
    }
    func chageName() {
        if self.name != "" {
            service?.changeName(name)
        }
        self.editField = false
    }
    //func chageFontSize(on sise: Double){}
    //func chageAccentColor(on sise: Double){}
}
