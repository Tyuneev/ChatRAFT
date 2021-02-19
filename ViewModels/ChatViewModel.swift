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
    private let service: MessegerServiceProtocol
    @Published var messeges: [Messege] = []
    @Published var members: [String:Member] = [:]
    @Published var scrolled = false
    @Published var messegeText = ""
    
    init() {
        self.service = FirebaseServices.shered.group.messeger
        FirebaseServices.shered.group.members.membersPublisher()
            .sink(receiveValue: { (member) in
                self.members[member.id] = member
            })
            .store(in: &cancellables)
        FirebaseServices.shered.group.members.delitedMembersPublisher()
            .sink(receiveValue: { (member) in
                self.members[member.id] = nil
            })
            .store(in: &cancellables)
        self.service.messegesPublisher()
            .sink(receiveValue: { (messege) in
                self.messeges.append(messege)
            })
            .store(in: &cancellables)
    }
    
    func sendMessege(){
        if self.messegeText != "" {
            service.sendMessege(Messege(content: messegeText)) { error in
                if let error = error  {
                    print(error.localizedDescription)
                }
            }
        }
        self.messegeText = ""
    }
}
