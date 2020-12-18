//
//  HomeViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 16.12.2020.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    //private var cancellables = Set<AnyCancellable>()
    private let model: Model
    init(model: Model) {
        self.model = model
    }
//    lazy var chatViewModel = ChatViewModel(messeges: model.$messeges)
//    (service: model.servic, messegesPublisher: model.$messeges.eraseToAnyPublisher(),
//                                            messeges: model.messeges)
    lazy var singUpViewModel = SingUpViewModel()
    lazy var settingsViewModel = SettingsViewModel()
    lazy var geopositionsViewModel = SettingsViewModel()
    lazy var chatViewModel = ChatViewModel(model: model)
    
}
