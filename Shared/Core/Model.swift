//
//  Models.swift
//  ChatRAFT
//
//  Created by Алексей Тюнеев on 10.12.2020.
//

import Foundation
import Combine
import CoreLocation
import MapKit

// обрабатывать подписку асинхронно


protocol ConectService {
    
    func curentStatus() -> UserStatus
    func MessegesPublisher() -> AnyPublisher<MessegeModel,Never>
    func MembersPublisher() -> AnyPublisher<MemberModel,Never>
    func UserStatusPublisher() -> AnyPublisher<UserStatus,Never>
    func ErrorsPublisher() -> AnyPublisher<Error,Never>
    
    func logIn(with email: String, password: String)
    func createUser(with email: String, password: String)
    func logOut()
    
    func joinGroup(id: String, userName: String)
    func createGroup(with userName: String)
    func leaveGroup()
    
    func changeName(_ name: String)
    func writeMessege(text: String, timeStamp: Date)
}

enum UserStatus {
    case loading
    case notLogIn
    case logIn
    case inGroup
}



struct MemberModel: Identifiable {
    var id = ""
    var name = ""
    var online = false
}

struct MessegeModel: Identifiable, Equatable {
    var id: String
    var content: String
    var user: String
    var timeStamp: Date
    var fromUser: Bool
}
struct GeoPoint {
    var tmp: Int? = nil
}

struct GeopositionModel {
    let user: String
    let point: GeoPoint
    var timeStamp: Date
    var fromUser: Bool
}

final class Model: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    let service: ConectService
    
    @Published var userStatus = UserStatus.loading
    @Published var messeges = [MessegeModel]()
    @Published var members: Dictionary<String,MemberModel> = [:]
    
    init(service: ConectService) {
        userStatus = service.curentStatus()
        self.service = service
        
        service.MessegesPublisher()
            .sink(receiveValue: { msg in
                self.messeges.append(msg)
            })
            .store(in: &cancellables)
        service.MembersPublisher()
            .sink(receiveValue: { mmbr in
                self.members[mmbr.id] = (mmbr.name == "" ? nil : mmbr)
            })
            .store(in: &cancellables)
        service.UserStatusPublisher()
            .sink(receiveValue: { s in
                self.userStatus = s // не синк а асигн нужно
            })
            .store(in: &cancellables)
        //все это на мейн кью   
    }
}









