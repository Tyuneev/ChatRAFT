//
//  GeopositionsViewModel.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 16.12.2020.
//

import Foundation
import MapKit
import Combine
import SwiftUI

final class GeopositionsViewModel: ObservableObject {
    private let service: GeopositionSheringServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var geopositions = [String: Geoposition]()
    private var userID: String = ""
    var members = [String:  Member]()
    @Published var coordinateRegion = MKCoordinateRegion()
    @Published var ItemsForAnotations = [Geoposition]()
    @Published var showDeteil = false
    
    var deteilForUseerWithId = ""
    var name: String {
        return members[self.deteilForUseerWithId]?.name ?? ""
    }
    var timeAgo: String {
        geopositions[deteilForUseerWithId]?.timeStamp.timeAgo() ?? ""
    }
    var selectedItem: Int = 0
    
    func showNext() {
        if ItemsForAnotations.count > selectedItem + 1 {
            setCoordinateRegionFor(geoposition: ItemsForAnotations[selectedItem + 1])
            selectedItem += 1
        } else if ItemsForAnotations.count > 0 {
            setCoordinateRegionFor(geoposition: ItemsForAnotations[0])
            selectedItem = 0
        }
    }
    
    func nameFor(_ item: Geoposition) -> String {
        if case Sender.id(let id) = item.sender {
            return members[id]?.name ?? " "
        } else {
            return members[userID]?.name ?? " "
        }
    }
    
    func showPrev() {
        if ItemsForAnotations.count > selectedItem - 1,  selectedItem - 1 >= 0 {
            setCoordinateRegionFor(geoposition: ItemsForAnotations[selectedItem - 1])
            selectedItem -= 1
        } else if selectedItem - 1 == -1, ItemsForAnotations.count > 0 {
            setCoordinateRegionFor(geoposition: ItemsForAnotations[ItemsForAnotations.count - 1])
            selectedItem = ItemsForAnotations.count - 1
        }
    }
    
    func showSelf() {
        for (index, item) in ItemsForAnotations.enumerated() {
            if item.sender == .user {
                setCoordinateRegionFor(geoposition: item)
                selectedItem = index
                return
            }
        }
    }
    
    func setCoordinateRegionFor(geoposition: Geoposition?) {
        let span = self.coordinateRegion.span
        let center = CLLocationCoordinate2D(
            latitude: geoposition?.latitude ?? 50,
            longitude: geoposition?.longitude ?? 50)
        guard let sender = geoposition?.sender else {
            return
        }
        withAnimation() {
            self.coordinateRegion = MKCoordinateRegion(center: center, span: span)
        }
        if case Sender.id(let id) = sender {
            self.showDeteilForUser(with: id)
        } else {
            self.showDeteilForUser(with: userID)
        }
    
    }
    
    func updateAnotoationsItems() {
        ItemsForAnotations = geopositions.values.map {$0}
    }
    
    func showDeteilForUser(with id: String) {
        deteilForUseerWithId = id
        withAnimation {
            showDeteil = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.deteilForUseerWithId == id {
                withAnimation(.easeOut) {
                    self.showDeteil = false
                }
            }
        }
    }

    
    init() {
        self.userID = FirebaseServices.shered.group.userInfo()?.id ?? ""
        self.service = FirebaseServices.shered.group.geopositionSharing
        FirebaseServices.shered.group.members.members()
            .forEach { member in
            self.members[member.id] = member
        }
        FirebaseServices.shered.group.members.membersPublisher()
            .sink { (member) in
                self.members[member.id] = member
            }
            .store(in: &cancellables)
        FirebaseServices.shered.group.members.delitedMembersPublisher()
            .sink {(member) in
                self.members[member.id] = nil
                self.geopositions[member.id] = nil
            }
            .store(in: &cancellables)
        FirebaseServices.shered.group.geopositionSharing.geopositionsPublisher()
            .sink { geo  in
                let oldCount = self.geopositions.count
                
                if case .id(let id) = geo.sender {
                    self.geopositions[id] = geo
                } else {
                    self.geopositions[self.userID] = geo
                }
                self.updateAnotoationsItems()
                if oldCount == 0 {
                    self.setCoordinateRegionFor(geoposition: self.ItemsForAnotations.first)
                }
            }
            .store(in: &cancellables)
        self.updateAnotoationsItems()
        self.setCoordinateRegionFor(geoposition: self.ItemsForAnotations.first)
    }
}

