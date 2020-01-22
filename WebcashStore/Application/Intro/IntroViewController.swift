//
//  IntroViewController.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/18/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Reachability setup
        NetworkManager.shared.checkNetworkConnection { isReaching in
            print("Network is reachable ::::::: \(isReaching)")
        }
        
        self.requestToken()
    }
    
    //MARK: - custom methods
    
    func requestToken() {
        IntroViewModel().requestToken { (err) in
            guard err == nil else {
                self.alert(title: "안내", message: err!.localizedDescription, okbtn: "확인") {
                    self.closeAppWithoutLookingLikeCrash()
                }
                return
            }
            self.setRootViewController(sbName: "Main", identifier: "rootController")
        }
    }
}
