//
//  IntroViewController.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/18/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    var pushNotificationVM: PushNotificationViewModel = PushNotificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Reachability setup
        NetworkManager.shared.checkNetworkConnection { isReaching in
            print("Network is reachable ::::::: \(isReaching)")
        }
        self.clearConstraintLog()
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
            
            self.requestDeviceToken()
        }
    }
    
    func requestDeviceToken() {
        self.pushNotificationVM.requestDeviceToken(deviceToken: ShareInstance.shared.device_token ?? "", completion: { (error) in
            self.setRootViewController(sbName: "Main", identifier: "rootController")
        })
    }
}
