//
//  AppDelegate.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/17/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import UIKit
import LanguageManager_iOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LanguageManager.shared.defaultLanguage = .en
        return true
    }


}

