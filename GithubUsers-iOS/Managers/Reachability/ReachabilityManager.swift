//
//  ReachabilityManager.swift
//  GithubUsers-iOS
//
//  Created by Aakash on 13/11/2021.
//

import Foundation

class ReachabilityManager {
    
    static let shared = ReachabilityManager()
    let reachability = try! Reachability()
    var isReachable: Bool {
        return reachability.connection != Reachability.Connection.unavailable
    }
    
    func startObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(notification:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(notification: Notification) {
        guard let reachability = notification.object as? Reachability else { return }
        
        var isConnected = false
        switch reachability.connection {
        case .wifi, .cellular: isConnected = true
        case .unavailable: isConnected = false
        default: break
        }
        
        // post network status notification
        NotificationCenter.default.post(name: .networkStatusNotification, object: isConnected, userInfo: nil)
    }
    
    func stopObserver() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
}

