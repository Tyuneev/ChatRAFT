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

struct GeopositionDocument: Codable,Identifiable,Hashable {
    @DocumentID var id : String?
    var timeStamp: Date
    var longitude: Double
    var latitude: Double
    
    enum CodingKeys: String,CodingKey {
        case id
        case timeStamp
        case longitude
        case latitude
    }
}

extension GeopositionModel {
    init(_ g: GeopositionDocument, userID: String) {
        user = g.id ?? ""
        latitude =  g.latitude
        longitude = g.longitude
        timeStamp = g.timeStamp
        fromUser = (userID == user)
    }
}



final class FirebaseService: ConectService {
    
    private var userID: String? = nil
    private var groupID: String? = nil
    private var messegesColectionName: String {
        "msgs"+(groupID ?? "")
    }
    private var membersColectionName: String {
        "mmbr"+(groupID ?? "")
    }
    private var geopositionsColectionName: String {
        "geopositions"+(groupID ?? "")
    }
    private lazy var firestore = Firestore.firestore()
    private let userSubject = PassthroughSubject<UserStatus, Never>()
    private let messegeSubject = PassthroughSubject<MessegeModel, Never>()
    private let memberSubject = PassthroughSubject<MemberModel, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()
    private let geopositionSubject = PassthroughSubject<GeopositionModel, Never>()
    
    init() {
        FirebaseApp.configure()
        userID = Auth.auth().currentUser?.uid
        if let user = userID {
            self.firestore
                .collection("usersGroups")
                .document(user)
                .getDocument { (snap, error) in
                    guard let doc = snap?.data() as? [String: String],
                          error == nil,
                          doc["group"] != "" else {
                        self.userSubject.send(.logIn)
                        return
                    }
                    self.groupID = doc["group"]
                    self.getUserName()
                }
        } else {
            self.userSubject.send(.notLogIn)
        }
    }

    
    func sendGeoposition(_ geoposition: GeopositionModel){
        guard let user = self.userID else {
            errorSubject.send("Не найденны данные пользователя")
            return
        }
        self.firestore
            .collection(self.geopositionsColectionName)
            .document(user)
            .setData([ "longitude" : geoposition.longitude, "latitude": geoposition.latitude, "timeStamp": Timestamp(date: geoposition.timeStamp)]) { error in
                guard error == nil else {
                    self.errorSubject.send(error ?? "Ошибка отправки геопозиции")
                    return
                }
            }
    }
    
    func MessegesPublisher() -> AnyPublisher<MessegeModel,Never> {
        let user = self.userID ?? ""
        self.firestore
            .collection(self.messegesColectionName)
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
        self.firestore
            .collection(self.membersColectionName)
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
        guard let user = self.userID else {
            errorSubject.send("Не найденны данные пользователя")
            return
        }
        let messege = MessegeDocument(content: text, user: user, timeStamp: Date())
        do {
            _ = try firestore.collection(messegesColectionName).addDocument(from: messege)
        } catch {
            errorSubject.send(error)
        }
    }

    func createGroup(userName: String) {
        let group = UUID().uuidString
        
        self.joinGroup(groupID: group, userName: userName)
    }
        
    func createUser(with email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (res, error) in
            guard let result = res,
                  error == nil else {
                self.errorSubject.send(error ?? "Ошибка регистрации")
                return
            }
            self.firestore
                .collection("usersGroups")
                .document(result.user.uid)
                .setData(["group" : ""]) { error in
                    guard error == nil else {
                        self.errorSubject.send(error ?? "Ошибка регистрации")
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
                self.errorSubject.send(error ?? "Ошибка авторизации")
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
                    self.groupID = doc["group"]
                    self.getUserName()
                }
        }
    }
    
    private func getUserName(){
        self.firestore
            .collection(self.membersColectionName)
            .document(self.userID ?? "")
            .getDocument { (snap, error) in
                guard //let doc = snap?.data() as? [String: Any],
                      let name = snap?.data()?["name"] as? String,
                      error == nil else {
                    self.errorSubject.send("Не найдено имя пользователя в группе")
                    return
                }
                //let name = doc?["name"]
                self.userSubject.send(.inGroup(groupID: self.groupID ?? "", userName: name))
            }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            self.errorSubject.send(error)
            return
        }
        self.userID = nil
        self.groupID = nil
        self.userSubject.send(.notLogIn)
    }
    
    func joinGroup(groupID: String, userName: String) {
        self.groupID = groupID
        guard let user = self.userID else {
            self.errorSubject.send("Вход не выполнен")
            return
        }
        self.firestore
            .collection(self.membersColectionName)
            .document(user)
            .setData(["memberID": user,
                      "name": userName,
                      "isOnline": false]) { err in
                if err != nil {
                    self.errorSubject.send(err ?? "Ошибка подключения")
                    return
                }
                self.firestore
                    .collection("usersGroups")
                    .document(user)
                    .setData(["group" : groupID]) { err in
                        if err != nil {
                            self.errorSubject.send(err ?? "Ошибка подключения")
                            return
                        }
                        self.groupID = groupID
                        self.userSubject.send(.inGroup(groupID: groupID, userName: userName))
                    }
                }
    }
    
    func leaveGroup() {
        guard let user = self.userID else {
            self.errorSubject.send("Ошибка данных пользователя")
            return
        }
        self.firestore
            .collection(self.membersColectionName)
            .document(user)
            .delete() { err in
                if err != nil {
                    self.errorSubject.send(err ?? "Ошибка при выходе из группы")
                    return
                }
                self.firestore
                    .collection("usersGroups")
                    .document(user)
                    .updateData(["group" : ""]){ err in
                        if err != nil {
                            self.errorSubject.send(err ?? "Ошибка при выходе из группы")
                            return
                        }
                        self.groupID = nil
                        self.userSubject.send(.logIn)
                    }
            }
    }
    
    func curentStatus() -> UserStatus {
        if (userID != nil) && (groupID != nil) {
            return .inGroup(groupID: groupID ?? "", userName: "Залупа")
        } else if (userID != nil) {
            return .logIn
        } else {
            return .notLogIn
        }
    }

    func ErrorsPublisher() -> AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    func GeopositionsPublisher() -> AnyPublisher<GeopositionModel,Never>{
        self.firestore
            .collection(self.geopositionsColectionName)
            .addSnapshotListener { (snap, err) in
                guard let data = snap else {
                    return
                }
                data.documentChanges
                    .forEach { (doc) in
                        if let geoposition = try? doc.document.data(as: GeopositionDocument.self) {
                            self.geopositionSubject.send(GeopositionModel(geoposition, userID: self.userID ?? ""))
                        }
                    }
            }
        return self.geopositionSubject.eraseToAnyPublisher()
    }

    func changeName(_ name: String) {
        guard let user = self.userID else {
            self.errorSubject.send("Ошибка данных пользователя")
            return
        }
        self.firestore
            .collection(self.membersColectionName)
            .document(user)
            .updateData(["name": name]){ (err) in
                if let err = err {
                    self.errorSubject.send(err)
                }
            }
    }
}
