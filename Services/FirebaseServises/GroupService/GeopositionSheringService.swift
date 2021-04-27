//
//  GeopositionSheringService.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 07.02.2021.
//

import Foundation
import Firebase
import Combine
import FirebaseFirestoreSwift

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

class GeopositionSheringService: GeopositionSheringServiceProtocol {
    var userID: String? = nil
    var groupID: String? = nil
    private var geopositionsColectionName: String? = nil
    private let geopositionsSubject = PassthroughSubject<Geoposition, Never>()
    private var snapshotListener: ListenerRegistration? = nil
    
    func setUserID(_ id: String? = nil) {
        self.userID = id
    }
    
    func setGroupID(_ id: String? = nil) {
        groupID = id
        if let id = id {
            self.geopositionsColectionName = "geopositions" + id
        }
        else {
            geopositionsColectionName = nil
        }
    }
    
    func addSnapshotListener() {
        guard let geopositionsColectionName = geopositionsColectionName,
              let userID = userID else {
            return
        }
        self.snapshotListener = Firestore.firestore()
            .collection(geopositionsColectionName)
            .addSnapshotListener { (data, err) in
                data?.documentChanges
                    .forEach { (doc) in
                        if let geoposition = try? doc.document.data(as: GeopositionDocument.self) {
                            self.geopositionsSubject.send(Geoposition(document: geoposition, userID: userID))
                        }
                    }
            }
    }

    func removeSnapshotListener() {
        self.snapshotListener?.remove()
        self.snapshotListener = nil
    }
    
    func geopositionsPublisher() -> AnyPublisher<Geoposition, Never> {
        return geopositionsSubject.eraseToAnyPublisher()
    }
    
    func getLastGeopositions() -> [Geoposition] {
        [] //бд
    }
    
    func sendGeoposition(_ geoposition: Geoposition) {
        guard let geopositionsColectionName  = geopositionsColectionName,
              let userID = self.userID else {
            return
        }
        do {
            try Firestore.firestore()
                .collection(geopositionsColectionName)
                .document(userID)
                .setData(from: geoposition.makeDocument(with: userID))
        } catch {
            print(error)
        }
    }
    
    func deleteDocument() {
        guard let geopositionsColectionName = geopositionsColectionName,
              let userID = userID else {
            return
        }
        Firestore.firestore()
            .collection(geopositionsColectionName)
            .document(userID)
            .delete()
    }
}

extension Geoposition {
    init(document: GeopositionDocument, userID: String) {
        self.latitude = document.latitude
        self.longitude = document.latitude
        self.timeStamp = document.timeStamp
        let senderID = document.id ?? ""
        self.sender = (senderID == userID ? .user : .id(senderID))
    }
    func makeDocument(with userID: String) -> GeopositionDocument {
        let document = GeopositionDocument(id: userID, timeStamp: self.timeStamp, longitude: self.longitude, latitude: self.latitude)
        return  document
    }
}

