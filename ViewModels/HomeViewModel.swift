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
    @Published var userState = UserState.loading
    
    init() {
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

