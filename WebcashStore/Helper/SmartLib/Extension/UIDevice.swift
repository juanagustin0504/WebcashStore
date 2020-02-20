//
//  UIDevice.swift
//  SmartLib
//
//  Created by God Save The King on 2020/01/08.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import LocalAuthentication

enum BiometryType: String {
    case none = "None"
    case faceID = "Face ID"
    case touchID = "Touch ID"
    case passcode = "Passcode"
}

extension UIDevice {
    
    public struct ScreenSize {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }

    enum DeviceScreenSize {
        case Mini           // iPhone 4 4s 5 or 5S or 5C or 5SE
        case Meduim         // iPhone 6/6S/7/8
        case Plus           // iPhone 6+/6S+/7+/8+
        case XSerial        // iPhone X, XS, 11Pro, iPhone XR, 11
        case XMaxSerial     // iPhone XS Max, 11Pro Max
    }
    
    private static func deviceId() -> Int {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 960:
                return 0
            case 1136:
                return 1
            case 1334:
                return 2
            case 1920, 2208:
                return 3
            case 2436:
                return 4
            case 2688:
                return 5
            case 1792:
                return 6
            default:
                return 999
            }
        }
        return 0
    }
    
    static func getDeviceScreenType() -> DeviceScreenSize {
        let _deviceId = Self.deviceId()
        if _deviceId == 0 || _deviceId == 1 { return .Mini }
        else if _deviceId == 2 { return .Meduim }
        else if _deviceId == 3 { return .Plus }
        else if _deviceId == 4 || _deviceId == 6 { return .XSerial }
        else if _deviceId == 5 { return .XMaxSerial }
        else { return .Meduim }
    }
    
    
    public enum EnumModel: String {
        case simulator     = "simulator/sandbox",
        //iPod
        iPod1              = "iPod 1",
        iPod2              = "iPod 2",
        iPod3              = "iPod 3",
        iPod4              = "iPod 4",
        iPod5              = "iPod 5",
        
        //iPad
        iPad2              = "iPad 2",
        iPad3              = "iPad 3",
        iPad4              = "iPad 4",
        iPadAir            = "iPad Air ",
        iPadAir2           = "iPad Air 2",
        iPad5              = "iPad 5", //aka iPad 2017
        iPad6              = "iPad 6", //aka iPad 2018
        
        //iPad mini
        iPadMini           = "iPad Mini",
        iPadMini2          = "iPad Mini 2",
        iPadMini3          = "iPad Mini 3",
        iPadMini4          = "iPad Mini 4",
        
        //iPad pro
        iPadPro9_7         = "iPad Pro 9.7\"",
        iPadPro10_5        = "iPad Pro 10.5\"",
        iPadPro12_9        = "iPad Pro 12.9\"",
        iPadPro2_12_9      = "iPad Pro 2 12.9\"",
        
        //iPhone
        iPhone4            = "iPhone 4",
        iPhone4S           = "iPhone 4S",
        iPhone5            = "iPhone 5",
        iPhone5S           = "iPhone 5S",
        iPhone5C           = "iPhone 5C",
        iPhone6            = "iPhone 6",
        iPhone6plus        = "iPhone 6 Plus",
        iPhone6S           = "iPhone 6S",
        iPhone6Splus       = "iPhone 6S Plus",
        iPhoneSE           = "iPhone SE",
        iPhone7            = "iPhone 7",
        iPhone7plus        = "iPhone 7 Plus",
        iPhone8            = "iPhone 8",
        iPhone8plus        = "iPhone 8 Plus",
        iPhoneX            = "iPhone X",
        iPhoneXS           = "iPhone XS",
        iPhoneXSMax        = "iPhone XS Max",
        iPhoneXR           = "iPhone XR",
        iPhone11           = "iPhone 11",
        iPhone11Pro        = "iPhone 11 Pro",
        iPhone11ProMax     = "iPhone 11 Pro Max",
        
        //Apple TV
        AppleTV            = "Apple TV",
        AppleTV_4K         = "Apple TV 4K",
        unrecognized       = "?unrecognized?"
    }
    
    public static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    public static func hapticWithStyle(style :  UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    public static func hapticWithType(type : UINotificationFeedbackGenerator.FeedbackType = .success) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
    
    public var type: EnumModel {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
                
            }
        }
        let modelMap : [ String: EnumModel ] = [
            "i386": .simulator,
            "x86_64": .simulator,
            
            //iPod
            "iPod1,1": .iPod1,
            "iPod2,1": .iPod2,
            "iPod3,1": .iPod3,
            "iPod4,1": .iPod4,
            "iPod5,1": .iPod5,
            
            //iPad
            "iPad2,1": .iPad2,
            "iPad2,2": .iPad2,
            "iPad2,3": .iPad2,
            "iPad2,4": .iPad2,
            "iPad3,1": .iPad3,
            "iPad3,2": .iPad3,
            "iPad3,3": .iPad3,
            "iPad3,4": .iPad4,
            "iPad3,5": .iPad4,
            "iPad3,6": .iPad4,
            "iPad4,1": .iPadAir,
            "iPad4,2": .iPadAir,
            "iPad4,3": .iPadAir,
            "iPad5,3": .iPadAir2,
            "iPad5,4": .iPadAir2,
            "iPad6,11": .iPad5, //aka iPad 2017
            "iPad6,12": .iPad5,
            "iPad7,5": .iPad6, //aka iPad 2018
            "iPad7,6": .iPad6,
            
            //iPad mini
            "iPad2,5": .iPadMini,
            "iPad2,6": .iPadMini,
            "iPad2,7": .iPadMini,
            "iPad4,4": .iPadMini2,
            "iPad4,5": .iPadMini2,
            "iPad4,6": .iPadMini2,
            "iPad4,7": .iPadMini3,
            "iPad4,8": .iPadMini3,
            "iPad4,9": .iPadMini3,
            "iPad5,1": .iPadMini4,
            "iPad5,2": .iPadMini4,
            
            //iPad pro
            "iPad6,3": .iPadPro9_7,
            "iPad6,4": .iPadPro9_7,
            "iPad7,3": .iPadPro10_5,
            "iPad7,4": .iPadPro10_5,
            "iPad6,7": .iPadPro12_9,
            "iPad6,8": .iPadPro12_9,
            "iPad7,1": .iPadPro2_12_9,
            "iPad7,2": .iPadPro2_12_9,
            
            //iPhone
            "iPhone3,1": .iPhone4,
            "iPhone3,2": .iPhone4,
            "iPhone3,3": .iPhone4,
            "iPhone4,1": .iPhone4S,
            "iPhone5,1": .iPhone5,
            "iPhone5,2": .iPhone5,
            "iPhone5,3": .iPhone5C,
            "iPhone5,4": .iPhone5C,
            "iPhone6,1": .iPhone5S,
            "iPhone6,2": .iPhone5S,
            "iPhone7,1": .iPhone6plus,
            "iPhone7,2": .iPhone6,
            "iPhone8,1": .iPhone6S,
            "iPhone8,2": .iPhone6Splus,
            "iPhone8,4": .iPhoneSE,
            "iPhone9,1": .iPhone7,
            "iPhone9,3": .iPhone7,
            "iPhone9,2": .iPhone7plus,
            "iPhone9,4": .iPhone7plus,
            "iPhone10,1": .iPhone8,
            "iPhone10,4": .iPhone8,
            "iPhone10,2": .iPhone8plus,
            "iPhone10,5": .iPhone8plus,
            "iPhone10,3": .iPhoneX,
            "iPhone10,6": .iPhoneX,
            "iPhone11,2": .iPhoneXS,
            "iPhone11,4": .iPhoneXSMax,
            "iPhone11,6": .iPhoneXSMax,
            "iPhone11,8": .iPhoneXR,
            "iPhone12,1": .iPhone11,
            "iPhone12,3": .iPhone11Pro,
            "iPhone12,5": .iPhone11ProMax,
            
            //AppleTV
            "AppleTV5,3": .AppleTV,
            "AppleTV6,2": .AppleTV_4K
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return EnumModel.unrecognized
    }
    
    static func getOSVerstion() -> Double {
        Double(UIDevice.current.systemVersion) ?? 0
    }
    
    /// 앱 버전 가져옴
    static func getAppVersion() -> String {
        let mainBundleDictionary = Bundle.main.infoDictionary! as NSDictionary
        return mainBundleDictionary.object(forKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    static func getAppVersionInt() -> Int {
        let plainVersion = UIDevice.getAppVersion().replace(of: ".", with: "")
        let intVersion = Int(plainVersion) ?? 0
        return intVersion
    }
    
    static func isEnableAPNS() -> Bool {
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        return isRegisteredForRemoteNotifications
    }
    
    /// UUID 가져옴
    static func getUUID() -> String {
        (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    /// device 토큰 가져옴
    /// - Parameter deviceToken: 토큰 데이터
    static func getDeviceToken(deviceToken : Data) -> String {
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        return token
    }
    
    
    static func faceIDAvailable() -> Bool {
        if #available(iOS 11.0, *) {
            let context = LAContext()
            return (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) && context.biometryType == .faceID)
        }
        return false
    }
    
    static func checkSecurityType() -> BiometryType {
        let myContext = LAContext()
        
        let hasAuthenticationBiometrics = myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        let hasAuthentication = myContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        
        if #available(iOS 11.0, *) {
            if hasAuthentication {
                if hasAuthenticationBiometrics {
                    switch myContext.biometryType {
                    case .none: return .none
                    case .faceID: return .faceID
                    case .touchID: return .touchID
                    @unknown default:
                        fatalError()
                    }
                } else {
                    return .passcode
                }
            } else {
                return .none
            }
        } else {
            if hasAuthentication {
                if hasAuthenticationBiometrics {
                    return .touchID
                } else {
                    return .passcode
                }
            } else {
                return .none
            }
        }
    }
    
    /// Login into iPhone with security type
    /// - Parameters:
    ///   - type: Password, Touch ID, Face ID, None
    ///   - completion: True if login success
    static func loginWithSecurity(securityType type: BiometryType, completion: @escaping (Bool, Error?)  -> Void) {
        switch type {
        case .touchID, .passcode:
            LAContext().evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticaton is required.") { success, error in
                if !success {
                    print(":::::::::: Security :::::::::: \(error.debugDescription)")
                }
                
                DispatchQueue.main.async {
                    completion(success,error)
                }
            }
        case .faceID:
            LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "FaceID Authenticaton is required.") { success, error in
                if !success {
                    print(":::::::::: Security :::::::::: \(error.debugDescription)")
                }
                DispatchQueue.main.async {
                    completion(success,error)
                }
            }
        default:
            DispatchQueue.main.async {
                completion(false,nil)
            }
            break
        }
    }
}
