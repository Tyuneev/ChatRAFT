//
//  FirebaseServices.swift
//  ChatRAFT
//
//  Created by Алексей Тюнеев on 12.12.2020.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth
import Combine

extension String: Error {}

extension MessegeModel {
    init(_ m: MessegeDocument, userID: String) {
        id = m.id ?? ""
        content = m.content
        user = m.user
        timeStamp =  m.timeStamp
        fromUser = (userID == user)
    }
}

extension MemberModel {
    init(_ mmbr: MemberDocument) {
        id = mmbr.memberID
        name = mmbr.name
        online = mmbr.isOnline
    }
}

struct MessegeDocument: Codable,Identifiable,Hashable {
    @DocumentID var id : String?
    var content : String
    var user : String
    var timeStamp: Date
    
    enum CodingKeys: String,CodingKey {
        case id
        case content
        case user
        case timeStamp
    }
}

struct MemberDocument: Codable,Identifiable,Hashable {
    @DocumentID var id : String?
    var memberID : String
    var name : String
    var isOnline: Bool
    
    enum CodingKeys: String,CodingKey {
        case id
        case memberID
        case name
        case isOnline
    }
}

final class FirebaseService: ConectService {
    
    private var userID: String? = nil
    private var grourID: String? = nil
    private let firestore = Firestore.firestore()
    private let userSubject = PassthroughSubject<UserStatus, Never>()
    private let messegeSubject = PassthroughSubject<MessegeModel, Never>()
    private let memberSubject = PassthroughSubject<MemberModel, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    init() {
        FirebaseApp.configure()
        userID = Auth.auth().currentUser?.uid
        
        if let group = UserDefaults.standard.string(forKey: "grourID") {
            grourID = group
//            self.firestore
//                .collection("mmbrs"+group)
        }
    }
    
    func MessegesPublisher() -> AnyPublisher<MessegeModel,Never> {
        let group = self.grourID ?? ""
        let user = self.userID ?? ""
        self.firestore
            .collection("msgs"+group)
            .order(by: "timeStamp", descending: false)
            .addSnapshotListener { (snap, err) in
                guard let data = snap else {
                    return
                }
                data.documentChanges
                    .filter({$0.type == .added})
                    .forEach { (doc) in
                        if let messege = try? doc.document.data(as: MessegeDocument.self){
                            self.messegeSubject.send(MessegeModel(messege, userID: user))
                        }
                    }
            }
        return messegeSubject.eraseToAnyPublisher()
    }
    
    func MembersPublisher() -> AnyPublisher<MemberModel,Never> {
        let group = self.grourID ?? ""
        self.firestore
            .collection("mmbrs"+group)
            .addSnapshotListener { (snap, err) in
                guard let data = snap else {
                    return
                }
                data.documentChanges
                    .forEach { (doc) in
                        if let mmbr = try? doc.document.data(as: MemberDocument.self) {
                            if doc.type == .removed {
                                self.memberSubject.send(MemberModel(id: mmbr.memberID))
                            } else {
                                self.memberSubject.send(MemberModel(mmbr))
                            }
                        }
                    }
            }
        return memberSubject.eraseToAnyPublisher()
    }
    
    func UserStatusPublisher() -> AnyPublisher<UserStatus, Never> {
        return userSubject.eraseToAnyPublisher()
    }
    
    func writeMessege(text: String, timeStamp: Date) {
        guard let user = self.userID,
              let group = self.userID else {
            return
            //throw "Auth error"
        }
        let messege = MessegeDocument(content: text, user: user, timeStamp: Date())
        do {
            _ = try firestore.collection("msgs"+group).addDocument(from: messege)
        } catch {
            print(error)
        }
    }

    func createGroup(with userName: String) {
//        guard let user = self.userID else {
//            print("Not log in")
//            return
//        }
        let group = UUID().uuidString
        self.joinGroup(id: group, userName: userName)
//        firestore.collection("mmbr"+group).document(user).getDocument{ (doc, err) in
//            if let doc = doc, doc.exists {
//                return
//            } else {
//                self.joinGroup(id: group, userName: userName)
//            }
//        }
    }
        
    func createUser(with email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (res, error) in
            guard let result = res,
                  error == nil else {
                return
            }
            self.firestore
                .collection("usersGroups")
                .document(result.user.uid)
                .setData(["group" : ""]) { error in
                    guard error == nil else {
                        return
                    }
                    self.userID = result.user.uid
                    self.userSubject.send(.logIn)
                }
        }
    }
    
    func logIn(with email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (res, error) in
            guard let result = res,
                  error == nil else {
                return
            }
            self.userID = result.user.uid
            self.firestore
                .collection("usersGroups")
                .document(result.user.uid)
                .getDocument { (snap, error) in
                    guard let doc = snap?.data() as? [String: String],
                          error == nil,
                          doc["group"] != "" else {
                        self.userSubject.send(.logIn)
                        return
                    }
                    self.grourID = doc["group"]
                    self.userSubject.send(.inGroup)
                }
        }
    }
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch{
            print(error)
            return
        }
        self.userID = nil
        self.grourID = nil
        self.userSubject.send(.notLogIn)
    }
    
    func joinGroup(id: String, userName: String) {
        guard let user = self.userID else {
            print("Not log in")
            return
        }
        self.firestore
            .collection("mmbr"+id)
            .document(user)
            .setData(["memberID": user,
                      "name": userName,
                      "isOnline": false]) { err in
                if err != nil {
                    return
                }
                self.firestore
                    .collection("usersGroups")
                    .document(user)
                    .setData(["group" : id]) { err in
                        if err != nil {
                            return
                        }
                        self.grourID = id
                        self.userSubject.send(.inGroup)
                    }
                }
    }
    
    func leaveGroup() {
        guard let user = self.userID,
              let group = self.userID else {
            print("error")
            return
        }
        self.firestore
            .collection("mmbr"+group)
            .document(user)
            .delete() { err in
                if err != nil {
                    print("Dell error")
                    return
                }
                self.firestore
                    .collection("usersGroups")
                    .document(user)
                    .updateData(["group" : ""]){ err in
                        if err != nil {
                            print("Dell error")
                            return
                        }
                        self.grourID = nil
                        self.userSubject.send(.logIn)
                    }
            }
    }
    
    func curentStatus() -> UserStatus {
        if (userID != nil) && (grourID != nil) {
            return .inGroup
        } else if (userID != nil) {
            return .logIn
        } else {
            return .notLogIn
        }
    }

    func ErrorsPublisher() -> AnyPublisher<Error, Never> {
        return  errorSubject.eraseToAnyPublisher()
    }

    func changeName(_ name: String) {
        guard let user = self.userID,
              let group = self.userID else {
            print("error")
            return
        }
        self.firestore
            .collection("mmbr"+group)
            .document(user)
            .updateData(["name": name])
    }
}
