//
//  ChatViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 16.12.2020.
//

import Foundation
import Combine

final class ChatViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let service: ConectService
    @Published var messeges: [MessegeModel] = []
    @Published var members: [String:MemberModel] = [:]
    @Published var scrolled = false
    @Published var messegeText = ""
    
    init(model: Model) {
        self.service = model.service
        self.messeges = model.messeges
        self.members = model.members
        model.$members
            .assign(to: \.members, on: self)
            .store(in: &cancellables)
        model.$messeges
            .assign(to: \.messeges, on: self)
            .store(in: &cancellables)
    }
    
    func sendMessege(){
        if self.messegeText != "" {
            try! service.writeMessege(text: self.messegeText, timeStamp: Date())
            self.messegeText = ""
        }
    }
}
