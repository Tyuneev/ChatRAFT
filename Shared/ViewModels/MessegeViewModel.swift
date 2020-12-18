//
//  MessegeViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 16.12.2020.
//

import Foundation

struct MessegeViewModel {
    let from: MemberModel
    let messege: MessegeModel
    init(_ messege: MessegeModel, from: MemberModel){
        self.from = from
        self.messege = messege
    }
}
