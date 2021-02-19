//
//  MessegeViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 16.12.2020.
//

import Foundation

struct MessegeViewModel {
    let from: Member
    let messege: Messege
    init(_ messege: Messege, from: Member?){
        self.from = from ?? Member(id: "", name: "")
        self.messege = messege
    }
    var fromUser: Bool {
        return messege.sender == .user
    }
}
