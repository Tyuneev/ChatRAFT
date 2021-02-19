//
//  Models.swift
//  ChatRAFT
//
//  Created by Алексей Тюнеев on 10.12.2020.
//
//

import Foundation
import Combine
import CoreLocation
import MapKit

//UserInfo

enum UserState {
    case loading
    case notLogin
    case login
    case inGroup
}

struct GroupInfo {
    let id: String
}

struct Member: Identifiable {
    let id: String
    let name: String
    //let groupID: String
   // let emoji: String// = "🐶"
    var online = false
}


enum Sender: Equatable {
    case id(String)
    case user
}

struct Messege: Identifiable, Equatable {
    let id: String
    let content: String
    let timeStamp: Date
    let sender: Sender
    init(content: String) {
        self.id = UUID().uuidString
        self.content = content
        self.timeStamp  = Date()
        self.sender = .user
    }
}

struct Geoposition: Equatable, Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    let timeStamp: Date
    let sender: Sender
}
