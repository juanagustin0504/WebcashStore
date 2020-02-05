//
//  SettingsModel.swift
//  WebcashStore
//
//  Created by Webcash on 2020/02/03.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

struct SettingsModel {
    
    struct Request : Encodable {
        let divece_token    : String
        let platform_name   : String
        let platform_version: String
        let platform_type   : String
//        "device_token":"3",
//        "platform_name":"2",
//        "platform_version":"2",
//        "platform_type":"3"
    }
    
    struct Response : Decodable {
        
    }
    
    
}
