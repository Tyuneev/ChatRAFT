//
//  MembersViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 23.02.2021.
//

import Foundation
import Combine

class MembersViewModel: ObservableObject {
    @Published var members: [Member] = []
    private var cancellables = Set<AnyCancellable>()
    let service: MembersServiceProtocol
    init() {
        self.service = FirebaseServices.shered.group.members
        members = service.members()
        self.service.membersPublisher()
            .sink { member in
                if let index  = self.indexOf(member){
                    self.members[index] = member
                } else {
                    self.members.append(member)
                }
                
            }
            .store(in: &cancellables)
        self.service.delitedMembersPublisher()
            .sink { member in
                if let index = self.indexOf(member) {
                    self.members.remove(at: index)
                }
            }
            .store(in: &cancellables)
       
    }
    private func indexOf(_ member: Member) -> Int? {
        for (index, mmbr) in members.enumerated() {
            if mmbr.id == member.id {
                return index
            }
        }
        return nil
    }
}
