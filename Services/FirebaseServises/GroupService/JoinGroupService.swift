//
//  JoinGroupService.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 19.02.2021.
//

import Foundation
import Firebase

class JoinGroupService {
    func joinGroup(groupInfo: GroupInfo, userInfo: Member, comlition: @escaping (Error?) -> ()) {
        self.checkExistingOfGoupWith(id: groupInfo.id) { exist in
            if exist {
                self.addToMemmbers(groupInfo: groupInfo, userInfo: userInfo) { error in
                    comlition(error)
                }
            } else {
                comlition("Группы с таким id  не существует")
            }
        }
    }
    
    func createGroup(with id: String, userInfo: Member, comlition: @escaping (Error?) -> ()) {
        self.addToMemmbers(groupInfo: GroupInfo(id: id), userInfo: userInfo) { error in
            comlition(error)
        }
    }
    
    private func addGroupToUserDocument(groupInfo: GroupInfo, userInfo: Member, comlition: @escaping (Error?) -> ()) {
        Firestore.firestore()
            .collection("usersGroups")
            .document(userInfo.id)
            .setData(["group" : groupInfo.id]) { error in
                if let error = error {
                    comlition(error)
                } else {
                    comlition(nil)
                }
            }
    }
    
    private func checkExistingOfGoupWith(id: String, comlition: @escaping (Bool) -> ()) {
        comlition(true)
    }
    
    private func addToMemmbers(groupInfo: GroupInfo, userInfo: Member, comlition: @escaping (Error?) -> ()) {
         _ = try? Firestore.firestore()
                .collection("mmbr" + groupInfo.id)
                .document(userInfo.id)
                .setData(from: userInfo.makeDocument(with: userInfo.id)) { error in
                    if let error = error {
                        return comlition(error)
                    } else {
                        self.addGroupToUserDocument(groupInfo: groupInfo, userInfo: userInfo) { error in
                            comlition(error)
                        }
                    }
                }
    }
}
