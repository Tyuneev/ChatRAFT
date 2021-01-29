//
//  GeopositionsViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 16.12.2020.
//

import Foundation
import MapKit
import Combine

final class GeopositionsViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var geopositions = [GeopositionModel]()
    @Published var members = [String: MemberModel]()
    var inCentr: GeopositionModel? = nil
    @Published var needMoveMap = false
    
    func showNext(){
        needMoveMap = true
        guard let centr = inCentr else {
            return
        }
        for (index,  geo) in geopositions.enumerated(){
            if centr.user == geo.user {
                if index + 1 < geopositions.count,
                   members[geopositions[index+1].user] != nil {
                    inCentr = geopositions[index+1]
                    return
                } else {
                    inCentr = geopositions.first
                }
            }
        }
    }
    func showPrev(){
        needMoveMap = true
        guard let centr = inCentr else {
            return
        }
        for (index,  geo) in geopositions.enumerated(){
            if centr.user == geo.user {
                if index - 1 >= 0,
                   members[geopositions[index-1].user] != nil {
                    inCentr = geopositions[index - 1]
                } else {
                    inCentr = geopositions.last
                }
            }
        }
    }
    func showSelf() {
        needMoveMap = true
        for geo in geopositions {
            if geo.fromUser {
                inCentr = geo
                return
            }
        }
    }
    
    private func selectCentrUser(this id: String){
        for geo in geopositions {
            if geo.user == id,
               members[geo.user] != nil {
                inCentr = geo
                return
            }
        }
        inCentr = geopositions.first
    }
    
    init(model: Model? = nil) {
        if let model = model {
            self.members = model.members
            model
                .$members
                .sink { members in
                    self.members = members
                    
//                    guard let centrGeopositionUserID = self.inCentr?.user, members[centrGeopositionUserID] != nil else {
//                        self.inCentr = self.geopositions.first
//                        return
//                    }
                }
                .store(in: &cancellables)
            model
                .$geopositions
                .sink { geo in
                    self.geopositions = geo.map{$0.value}
//                    if let centrUserID = self.inCentr?.user{
//                        self.selectCentrUser(this: centrUserID)
//                    }
                }
                .store(in: &cancellables)
        } else {
            self.members = [:]
        }
       
    }

}

