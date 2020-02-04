//
//  NetworkManager.swift
//  WebcashStore
//
//  Created by God Save The King on 1/22/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation
import UIKit
struct NetworkManager {
    static var  shared : NetworkManager! = NetworkManager()
    private lazy var reachability : Reachability! = Reachability()
    
    private init() {}
    
    func checkNetworkConnection(completion : @escaping Completion_Bool) {
        NetworkManager.shared.reachability.whenReachable = { _ in
            completion(true)
            print("Networking is reachable")
        }
        
        NetworkManager.shared.reachability.whenUnreachable = { _ in
            completion(false)
            print("Networking is unreachable")
        }
        
        do{
            try NetworkManager.shared.reachability.startNotifier()
        } catch {
            print("Could not strat notifier")
        }
    }
    
    func showNetworkIndicator(isShowing show: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = show
        }
    }
    
}
