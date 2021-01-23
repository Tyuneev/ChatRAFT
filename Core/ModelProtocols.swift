//
//  ModelProtocols.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 13.01.2021.
//

import Foundation
import Combine
import CoreLocation
import MapKit
import Network



//пока не нужно
/*
protocol AuthenticationServiceProtocol {
    func logIn(with email: String, password: String)
    func createUser(with email: String, password: String)
    func logOut()
}
*/

struct GroupInfo {
    let id: String
}

struct UserInfo {
    let id: String
    let name: String
    let emoji: String// = "🐶"
}

protocol UserStatePublisherProtocol {
    func getUserStatusPublisher() -> AnyPublisher<UserStatus,Never>
}

protocol MessegerServiceProtocol {
    func getMessegesPublisher() -> AnyPublisher<MessegeModel,Never>
    func getMesseges(from: Date, to: Date)
    func startRecivingMesseges()
    func sendMessege(_ messege: MessegeModel)
}


protocol GroupServiceProtocol: UserStatePublisherProtocol {
    func joinGroup(groupInfo: GroupInfo, userInfo: UserInfo)
    func createGroup(userName: UserInfo)
    func GetGroupInfo() -> GroupInfo
    func leaveGroup()
    func getMembersPublisher() -> AnyPublisher<MemberModel,Never>
    func changeUserInfo(_ new: UserInfo)
}

protocol GeopositionSheringServiceProtocol {
    func getGeopositionPublisher() -> AnyPublisher<GeopositionModel,Never>
    func sendGeoposition(_ geoposition: GeopositionModel)
}

protocol ErrorsPublisherProtocol {
    func getErrorsPublisher() -> AnyPublisher<Error,Never>
}




protocol ConectService {
    func curentStatus() -> UserStatus
    func MessegesPublisher() -> AnyPublisher<MessegeModel,Never>//+
    func MembersPublisher() -> AnyPublisher<MemberModel,Never>//+
    func UserStatusPublisher() -> AnyPublisher<UserStatus,Never>
    func ErrorsPublisher() -> AnyPublisher<Error,Never>//+
    func GeopositionsPublisher() -> AnyPublisher<GeopositionModel,Never>//+
    
    func logIn(with email: String, password: String)//+
    func createUser(with email: String, password: String)//+
    func logOut()//+
    
    func joinGroup(groupID: String, userName: String)//+
    func createGroup(userName: String)//+
    func leaveGroup()//+
    
    func changeName(_ name: String)
    func writeMessege(text: String, timeStamp: Date)//+
    
    func sendGeoposition(_ geoposition: GeopositionModel)
}

