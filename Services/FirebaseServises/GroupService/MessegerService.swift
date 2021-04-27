//
//  MessegerService.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 07.02.2021.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift

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

class MessegerService: MessegerServiceProtocol {
    init() {
        self.firestore = Firestore.firestore()
    }
    let firestore: Firestore
    var userID: String? = nil
    var groupID: String? = nil
    private var messegesArray = [Messege]()
    private var messegesColectionName: String? = nil
    private let messegeSubject = PassthroughSubject<Messege, Never>()
    private var snapshotListener: ListenerRegistration? = nil
    
    func setUserID(_ id: String?) {
        self.userID = id
    }
    
    func setGroupID(_ id: String?) {
        self.messegesArray = [Messege]()
        groupID = id
        if let id = id {
            self.messegesColectionName = "msgs" + id
        }
        else {
            messegesColectionName = nil
        }
    }
    
    func removeSnapshotListener() {
        self.snapshotListener?.remove()
        self.snapshotListener = nil
    }
    
    func addSnapshotListener() {
        guard let messegesColectionName = messegesColectionName,
              let userID = userID else {
            return
        }
        self.snapshotListener = self.firestore
            .collection(messegesColectionName)
            .order(by: "timeStamp", descending: false)
            .addSnapshotListener { (data, err) in
                data?.documentChanges
                    .filter({$0.type == .added})
                    .forEach { (doc) in
                        if let messegeDocument = try? doc.document.data(as: MessegeDocument.self) {
                            let messege = Messege(document: messegeDocument, userID: userID)
                            self.messegesArray.append(messege)
                            self.messegeSubject.send(messege)
                        }
                    }
            }
    }
    
    func messeges()->[Messege] {
        return messegesArray
    }
    
    func messegesPublisher() -> AnyPublisher<Messege, Never> {
        return messegeSubject.eraseToAnyPublisher()
    }
    
    func getMesseges(from: Date, to: Date) {
        //что-то связанное с бд
    }
    
    func sendMessege(_ messege: Messege, comlition: @escaping (Error?) -> ()) {
        guard let messegesColectionName  = messegesColectionName,
              let userID = self.userID else {
            comlition("Нет данных пользователя")
            return
        }
        do {
            _ = try firestore.collection(messegesColectionName).addDocument(from: messege.makeDocument(with: userID))
            comlition(nil)
        } catch {
            comlition(error)
        }
    }
    
}

extension Messege {
    init(document: MessegeDocument, userID: String){
        self.id = document.id ?? ""
        self.content = document.content
        self.timeStamp = document.timeStamp
        let senderID = document.user
        self.sender = (senderID == userID ? .user : .id(document.user))
    }
    func makeDocument(with userID: String) -> MessegeDocument {
        let document = MessegeDocument(content: self.content, user: userID, timeStamp: self.timeStamp)
        return  document
    }
}

