//
//  ReachabilityMonitor.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 5/27/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityMonitor {
    typealias ReachabilityChangedHandler = (Bool) -> Void
    
    private let reachability = Reachability()!
    
    var onReachabilityChanged: ReachabilityChangedHandler? {
        didSet {
            updateReachabilityCallbacks()
            let reachable = reachability.connection != .none
            onReachabilityChanged?(reachable)
        }
    }
    
    init() {
        try? reachability.startNotifier()
    }
    
    deinit {
        reachability.stopNotifier()
    }
    
    private func updateReachabilityCallbacks() {
        reachability.whenReachable = { [weak self] _ in
            self?.onReachabilityChanged?(true)
        }
        reachability.whenUnreachable = { [weak self] _ in
            self?.onReachabilityChanged?(false)
        }
    }
}
