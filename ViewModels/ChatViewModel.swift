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
    @Published var messegeText = ""//вынести в отдельное view
    
    init() {
        self.service = FirebaseServices.shered.group.messeger
        FirebaseServices.shered.group.members.members()
            .forEach { member in
            self.members[member.id] = member
        }
        FirebaseServices.shered.group.members.membersPublisher()
            .sink(receiveValue: { (member) in
                self.members[member.id] = member
            })
            .store(in: &cancellables)
        self.service.messegesPublisher()
            .sink(receiveValue: { (messege) in
                self.messeges.append(messege)
            })
            .store(in: &cancellables)
        self.messeges = self.service.messeges()
    }
    
    func sendMessege() {
        for m in members {
            print(m.value.name)
        }
        if self.messegeText != "" {
            service.sendMessege(Messege(content: messegeText)) { error in
                if let error = error  {
                    print(error.localizedDescription)
                }
            }
        }
        self.messegeText = ""
    }
    
    func senderOf(_ messege: Messege) -> Member? {
        if case Sender.id(let id) = messege.sender {
            return members[id]
        } else {
            return nil
        }
    }
}
