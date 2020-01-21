//
//  CameraPermissionManager.swift
//  SmartLib
//
//  Created by 위차이 on 1/16/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation
import AVFoundation
import Speech
import CoreLocation
import Contacts
import UIKit

class PermissionManager :NSObject {
    
    
    //MARK: - properties
    fileprivate var completeBlock : ((Bool) -> ())!
    fileprivate var locationManger : CLLocationManager!
    
    //MARK: - methods
    
    /// Request camera permission
    /// - Parameter completion: complete closure
    func requestCameraPermission(completion: @escaping (Bool) -> ()) {
        
        var status : Bool = false
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("===========> Camera is `authorized`")
            status = true
        case .notDetermined:
            print("===========> Request Camera permission")
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    print("===========> Camera Permission `granted`")
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    print("===========> Camera Permission `denied`")
                    status = false
                }
            }
        case .restricted, .denied :
            print("===========> Camera Permission `denied` or `restricted`")
            status = false
        default:
            status = false
            print("===========> Camera Permission is unknown")
        }
        
        DispatchQueue.main.async {
            completion(status)
        }
    }
    
    /// Request speech permission
    /// - Parameter completion: complete closure
    func requestSpeechPermission(completion: @escaping (Bool) -> ()) {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var status : Bool = false
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    status = true
                    print("Speech recognition `authorized`")
                case .denied:
                    status = false
                    print("Speech recognition `denied`")
                case .notDetermined:
                    status = false
                    print("Speech recognition `notDetermined`")
                case .restricted:
                    status = false
                    print("Speech recognition not supported on this device")
                @unknown default:
                    status = false
                    print("Unknown")
                }
                completion(status)
            }
        }
    }
    
    /// Request location permission
    /// - Parameter completion: complete clousre
    func requestLocationPermission(completion: @escaping (Bool) -> ()) {
        locationManger = CLLocationManager()
        locationManger.allowsBackgroundLocationUpdates = true
        locationManger.pausesLocationUpdatesAutomatically = false
        locationManger.delegate = self
        
        self.completeBlock = completion
    }
    
    /// Request microphone permission
    /// - Parameter completion: complete clousre
    func requestMicrophonePermission(completion: @escaping (Bool) -> ()) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            print("Microphone Permission `granted`")
            completion(true)
        case .denied:
            print("Microphone Permission `denied`")
            completion(false)
        case .undetermined:
            print("Request Microphone Permission")
            AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
                if granted {
                    print("Microphone Permission `granted`")
                    completion(true)
                } else {
                    print("Microphone Permission `denied`")
                    completion(false)
                }
            }
        default:
            completion(false)
        }
    }
    
    /// Request Contact permission
    /// - Parameter completion: complete clousre
    func reqeustContactPermission(completion: @escaping (Bool) -> ()) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            print("Contact Permission `authorized`")
            completion(true)
        case .denied:
            print("Contact Permission `denied`")
            completion(false)
        case .restricted, .notDetermined:
            print("Request Contact Permission")
            CNContactStore().requestAccess(for: .contacts) { (status, err) in
                guard err == nil else {
                    print(err!.localizedDescription)
                    completion(false)
                    return
                }
                completion(true)
            }
        default:
            completion(false)
            break
        }
    }
    
    /// 푸시 알림 등록
    /// - Parameter delegate: delegate
    static func registerPushNotification(delegate : UNUserNotificationCenterDelegate) {
        let center = UNUserNotificationCenter.current()
        center.delegate = delegate
        center.requestAuthorization(options: [.sound,.alert,.badge], completionHandler: { (granted, error) in
            if error == nil {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        })
    }
}

//MARK: - location manager delegate method
extension PermissionManager : CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("locationManger requests authorization")
            manager.requestAlwaysAuthorization()
        case .authorizedAlways:
            print("locationManger permission is granted `AuthorizedAlways`")
            self.completeBlock(true)
        case .authorizedWhenInUse:
            print("locationManger permission is granted `WhenInUse`")
            self.completeBlock(true)
        case .denied:
            print("locationManger permission is denied `denied`")
            self.completeBlock(false)
        case .restricted:
            print("location not support `restricted`")
            self.completeBlock(false)
        default:
            self.completeBlock(false)
            break;
        }
    }
}
