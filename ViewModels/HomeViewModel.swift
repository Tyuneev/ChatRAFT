//
//  HomeViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 16.12.2020.
//

import Foundation
import Combine
import SwiftUI

final class HomeViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let model: Model
    @Published var userStatus: UserStatus
    @Published var alert = false
    @Published var alertContent = ""
    
    lazy var logInViewModel = LogInViewModel(service: model.service)
    lazy var joinGroupViewModel = JoinGroupViewModel(service: model.service)
    lazy var chatViewModel = ChatViewModel(model: model)
    lazy var membersViewModel = MembersViewModel(model: model)
    lazy var geopositionsViewModel = GeopositionsViewModel(model: model)
    lazy var settingsViewModel: SettingsViewModel = {
        switch self.userStatus {
        case let .inGroup(group, name):
            return SettingsViewModel(service: model.service, groupID: group, userName: name)
        default:
            return SettingsViewModel()
        }
    }()
    
    
    
    init(model: Model) {
        self.model = model
        self.userStatus = model.userStatus
        model.$userStatus
            .sink(receiveValue: { s in
                withAnimation(){
                    self.userStatus = s
                }
            })
            .store(in: &cancellables)
        model.service.ErrorsPublisher()
            .sink(receiveValue: { error in
                self.alertContent = error.localizedDescription
                self.alert = true
            })
            .store(in: &cancellables)
    }
}
