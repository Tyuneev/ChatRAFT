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

protocol UserStatePotocol {
    var userState: UserState { get }
    func userStatusPublisher() -> AnyPublisher<UserState,Never>
}

protocol ServiceStatePotocol {
    var serviceState: ServiceState { get }
    func changeState(to: ServiceState)
    func serviceStatePublisher() -> AnyPublisher<ServiceState,Never>
}

protocol AuthenticationServiceProtocol {
    func logIn(with email: String, password: String, comlition: @escaping (Error?)->())
    func createUser(with email: String, password: String, comlition: @escaping (Error?)->())
    func logOut()
}

protocol GroupServiceProtocol {
    func groupInfo() -> GroupInfo?
    func userInfo() -> Member?
    func leaveGroup(comlition: @escaping (Error?)->())
    func changeUserInfo(_ new: Member, comlition: @escaping (Error?)->())
    func joinGroup(groupInfo: GroupInfo, userInfo: Member, comlition: @escaping (Error?)->())
    func createGroup(userInfo: Member, comlition: @escaping (Error?)->())
    func userBecameOfline()
    func userBecameOnline()
    
    var messeger: MessegerServiceProtocol { get }
    var geopositionSharing: GeopositionSheringServiceProtocol { get }
    var members: MembersServiceProtocol { get }
}

protocol MessegerServiceProtocol {
    func messegesPublisher() -> AnyPublisher<Messege,Never>
    func messeges() -> [Messege]
    func sendMessege(_ messege: Messege, comlition: @escaping (Error?)->())
}

protocol GeopositionSheringServiceProtocol {
    func geopositionsPublisher() -> AnyPublisher<Geoposition,Never>
    func getLastGeopositions() -> [Geoposition]
    func sendGeoposition(_ geoposition: Geoposition)
}

protocol MembersServiceProtocol {
    func members() -> [Member]
    func membersPublisher() -> AnyPublisher<Member,Never>
    func delitedMembersPublisher() -> AnyPublisher<Member,Never>
}

extension String: Error { }
