//
//  NetworkMonitorProtocol.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 17..
//

import Foundation
import Reachability
import Combine

protocol NetworkMonitorProtocol {
    var isConnected: AnyPublisher<Bool, Never> {get}
}

class NetworkMonitor: NetworkMonitorProtocol {
    var isConnected: AnyPublisher<Bool, Never> {
        isConnectedSubject.eraseToAnyPublisher()
    }
    
    private var reachability: Reachability
    
    private let isConnectedSubject = CurrentValueSubject<Bool, Never>(false)
    
    init() {
        guard let reachibility = try? Reachability() else {
            fatalError("Failed to initialize Reachibility")
        }
        
        self.reachability = reachibility
        
        reachability.whenReachable = { [weak self]reachability in
            let isAvailable = reachability.connection != .unavailable
            self?.isConnectedSubject.send(isAvailable)
        }
        reachability.whenUnreachable = { [weak self]_ in
            self?.isConnectedSubject.send(false)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
