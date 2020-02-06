//
//  Share.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/20/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

struct ShareInstance {
    private init() {}
    static var shared = ShareInstance()
    
    // Token
    var access_token : String!

    // Device Token
    var device_token : String!
}
