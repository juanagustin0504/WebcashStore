//
//  AppDelegate.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/17/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import IQKeyboardManagerSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // LanguageManager
        LanguageManager.shared.defaultLanguage = .en
        
        
        //IQKeyboard
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // Firebase
        FirebaseApp.configure()
        
        return true
    }


}

