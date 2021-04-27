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
    private var groupService: GroupServiceProtocol
    @Published var userState = UserState.loading
    
    init() {
        groupService = FirebaseServices.shered.group
        let userStateService = FirebaseServices.shered.userState
        self.userState = userStateService.userState
        userStateService.userStatusPublisher()
            .sink { state in
                withAnimation {
                    self.userState = state
                }
            }
            .store(in: &cancellables)
    }
}

