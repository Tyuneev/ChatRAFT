//
//  GroupService.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 07.02.2021.
//

import Foundation
import Combine
import Firebase


class GroupService: GroupServiceProtocol {
    private var cancellables = Set<AnyCancellable>()
    
    init(statusService: ServiceStatePotocol) {
        self.statusService = statusService
        self.messegerService = MessegerService()
        self.membersService = MembersService()
        self.geopositionSharingService = GeopositionSheringService()
        self.createStateObserver()
        if case .checkUserGroup(let userID) =  statusService.serviceState {
            self.checkUserGroup(with: userID)
        }
    }
    
    private var user: Member? = nil
    private var statusService: ServiceStatePotocol
    
    private func createStateObserver() {
        self.statusService.serviceStatePublisher()
            .sink { state in
                switch state {
                case .checkUserGroup(let userID):
                    self.checkUserGroup(with: userID)
                case .inGroup(let groupID, let userID):
                    self.setData(groupID: groupID, userID: userID)
                case .login(_):
                    self.resetData()
                case .notLogin:
                    self.resetData()
                default:
                    return
                }
            }
            .store(in: &cancellables)
    }
    private func fetchUserInfo(groupID: String, userID: String) {
        Firestore.firestore()
            .collection("mmbr"+groupID)
            .document(userID)
            .getDocument { (snap, error) in
                guard let name = snap?.data()?["name"] as? String,
                      error == nil else {
                    self.statusService.serviceState = .login(userID: userID)
                    return
                }
                self.user = Member(id: userID, name: name, online: true)
                self.statusService.serviceState = .inGroup(groupID: groupID, userID: userID)
            }
    }
    
    private func setData(groupID: String, userID: String){
        self.messegerService.setUserID(userID)
        self.geopositionSharingService.setUserID(userID)
        self.membersService.setUserID(userID)
        self.membersService.setGroupID(groupID)
        self.messegerService.setGroupID(groupID)
        self.geopositionSharingService.setGroupID(groupID)
    }
    
    private func resetData(){
        self.messegerService.setUserID(nil)
        self.geopositionSharingService.setUserID(nil)
        self.membersService.setUserID(nil)
        self.membersService.setGroupID(nil)
        self.messegerService.setGroupID(nil)
        self.geopositionSharingService.setGroupID(nil)
    }
    
    func userInfo() -> Member? {
        return user
    }
    
    func groupInfo() -> GroupInfo? {
        guard case .inGroup(let groupID, _) = self.statusService.serviceState else {
           return nil
        }
        return GroupInfo(id: groupID)
    }
    
    private func checkUserGroup(with userID: String) {
        Firestore.firestore()
            .collection("usersGroups")
            .document(userID)
            .getDocument { (snap, error) in
                guard let groupID = (snap?.data() as? [String: String])?["group"],
                      error == nil,
                      groupID != "" else {
                    self.statusService.serviceState = .login(userID: userID)
                    return
                }
                self.fetchUserInfo(groupID: groupID, userID: userID)
            }
    }
    
    func changeUserInfo(_ new: Member, comlition: @escaping (Error?) -> ()) {
        guard case .inGroup(let groupID, let userID) = self.statusService.serviceState else {
            return comlition("Пользователь не обнаружен")
        }
        Firestore.firestore()
            .collection("mmbr"+groupID)
            .document(userID)
            .updateData(["name": new.name]) { (error) in
                if let error = error {
                    comlition(error)
                } else {
                    self.user = new
                    comlition(nil)
                }
            }
    }
 
    
    func joinGroup(groupInfo: GroupInfo, userInfo: Member, comlition: @escaping (Error?) -> ()) {
        guard case .login(let userID) = self.statusService.serviceState else {
            return comlition("Пользователь не обнаружен")
        }
        let user = Member(id: userID, name: userInfo.name)
        JoinGroupService().joinGroup(groupInfo: groupInfo, userInfo: user) { error in
            if let error = error {
                comlition(error)
            } else {
                self.statusService.serviceState = .inGroup(groupID: groupInfo.id, userID: userInfo.id)
                comlition(nil)
            }
        }
    }
    
    func createGroup(userInfo: Member, comlition: @escaping (Error?) -> ()) {
        guard case .login(let userID) = self.statusService.serviceState else {
            return comlition("Пользователь не обнаружен")
        }
        let user = Member(id: userID, name: userInfo.name)
        let groupID = UUID().uuidString
        JoinGroupService().createGroup(with: groupID, userInfo: user) { error in
            if let error = error {
                comlition(error)
            } else {
                self.statusService.serviceState = .inGroup(groupID: groupID, userID: userInfo.id)
                comlition(nil)
            }
        }
    }
    
    func leaveGroup(comlition: @escaping (Error?) -> ()) {
        guard case .inGroup(let groupID, let userID) = self.statusService.serviceState else {
            return comlition("Пользователь не обнаружен")
        }
        self.geopositionSharingService.deleteDocument()
        self.deleteGroupFromUserDocument(userID: userID)
        self.deleteMemberDocument(userID: userID, groupID: groupID)
        self.statusService.serviceState = .login(userID: userID)
    }
    
    private func deleteMemberDocument(userID: String, groupID: String) {
        Firestore.firestore()
            .collection("mmbr"+groupID)
            .document(userID)
            .delete()
    }
    
    private func deleteGroupFromUserDocument(userID: String) {
        Firestore.firestore()
            .collection("usersGroups")
            .document(userID)
            .updateData(["group" : ""])
    }
    
    private let messegerService: MessegerService
    private let geopositionSharingService: GeopositionSheringService
    private let membersService: MembersService
    
    var messeger: MessegerServiceProtocol {
        return messegerService
    }
    var geopositionSharing: GeopositionSheringServiceProtocol {
        return geopositionSharingService
    }
    var members: MembersServiceProtocol {
        return membersService
    }
}

extension Member {
    func makeDocument(with userID: String) -> MemberDocument {
        return MemberDocument.init(id: userID, name: self.name, isOnline: true)
    }
}
