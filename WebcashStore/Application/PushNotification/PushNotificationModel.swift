//
//  PushNotificationModel.swift
//  WebcashStore
//
//  Created by Webcash on 2020/02/03.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

struct PushNotificationModel {
    
    struct Request : Encodable {
        let device_token        : String
        let platform_name       : String
        let platform_version    : String
        let platform_type       : String
    }
    
    struct Response : Decodable {
        
    }
    
    
}
