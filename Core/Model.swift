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
import Network

// обрабатывать подписку асинхронно

enum UserStatus: Equatable {
    case loading
    case notLogIn
    case logIn
    case inGroup(groupID: String, userName: String)
    
}

enum ServiceAvailabilityStatus: Equatable {
    case availabil
    case notAvailabil
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

struct GeopositionModel {
    let user: String
    let latitude: Double
    let longitude: Double
    var timeStamp: Date
    var fromUser: Bool
}

final class Model: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    let service: ConectService
    
    @Published var userStatus = UserStatus.loading
    @Published var messeges = [MessegeModel]()
    @Published var geopositions = [GeopositionModel]()
    @Published var members: Dictionary<String,MemberModel> = [:]
    init(service: ConectService) {
        userStatus = .loading// service.curentStatus()
        self.service = service
        
        service.UserStatusPublisher()
            .sink(receiveValue: { [self] s in
                switch s {
                case .inGroup(_, _):
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
                default:
                    break
                }
                self.userStatus = s // не синк а асигн нужно
            })
            .store(in: &cancellables)
        //все это на мейн кью   
    }
}
