//
//  ReachabilityService.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 29.12.2020.
//

import Foundation
import Reachability
import Combine

enum ReachabilityStatus {
    case noInternet
    case IPv6(adres: String)
    case IPv4
}

protocol ReachabilityServiceProtocol {
    func ReachabilityPublisher() -> AnyPublisher<ReachabilityStatus,Never>
}

class IPv6reachability: ReachabilityServiceProtocol {
    private let reachability: Reachability?
    private let reachabilitySubject = PassthroughSubject<ReachabilityStatus, Never>()
    
    init() {
        reachability = try? Reachability()
    }
    
    private func configurate() {
        guard let reachability = reachability else {
            return
        }
        reachability.whenReachable = { [weak self] reachability in
            self?.reachabilitySubject.send(.IPv4)
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { [weak self] _ in
            self?.reachabilitySubject.send(.noInternet)
            print("Not reachable")
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func ReachabilityPublisher() -> AnyPublisher<ReachabilityStatus, Never> {
        return self.reachabilitySubject.eraseToAnyPublisher()
    }
}


///https://stackoverflow.com/questions/30748480/swift-get-devices-wifi-ip-address/30754194#30754194


