//
//  MembersService.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 07.02.2021.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift

struct MemberDocument: Codable,Identifiable,Hashable {
    @DocumentID var id : String?
    var name : String
    var isOnline: Bool
    
    enum CodingKeys: String,CodingKey {
        case id
        case name
        case isOnline
    }
}

class MembersService: MembersServiceProtocol {

    private var groupID: String? = nil
    private var userID: String? = nil
    private var membersColectionName: String? = nil
    private let membersSubject = PassthroughSubject<Member, Never>()
    private let delitedMembersSubject = PassthroughSubject<Member, Never>()
    private var snapshotListener: ListenerRegistration? = nil
    
    private func addSnapshotListener() {
        guard let membersColectionName = membersColectionName else {
            return
        }
        self.snapshotListener = Firestore.firestore()
            .collection(membersColectionName)
            .addSnapshotListener { (data, err) in
                data?.documentChanges
                    .forEach { (doc) in
                        if let memberDocument = try? doc.document.data(as: MemberDocument.self),
                           let member = Member(document: memberDocument)
                           {
                            if doc.type == .removed {
                                self.delitedMembersSubject.send(member)
                            } else {
                                self.membersSubject.send(member)
                            }
                        }
                    }
            }
    }
    
    private func removeSnapshotListener() {
        self.snapshotListener?.remove()
        self.snapshotListener = nil
    }
    
    func deleteMemberDocument(userID: String) {
        guard let membersColectionName  = membersColectionName else {
            return
        }
        Firestore.firestore()
            .collection(membersColectionName)
            .document(userID)
            .delete()
    }
    
    func setGroupID(_ id: String?) {
        if let id = id {
            self.membersColectionName = "mmbr" + id
        }
        else {
            membersColectionName = nil
        }
    }
    func setUserID(_ id: String?) {
        removeSnapshotListener()
        userID = id
        if id != nil {
            self.addSnapshotListener()
        }
    }
    
    func members() -> [Member] {
        return []
    }
    
    func membersPublisher() -> AnyPublisher<Member, Never> {
        membersSubject.eraseToAnyPublisher()
    }

    func delitedMembersPublisher() -> AnyPublisher<Member, Never> {
        delitedMembersSubject.eraseToAnyPublisher()
    }
}

extension Member {
    init?(document: MemberDocument) {
        guard let id = document.id else {
            return nil
        }
        self.id =  id
        self.name = document.name
        self.online = true
    }
}
