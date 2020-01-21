//
//  Response.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/20/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    
    var CODE    : Int?
    var MESSAGE : String?
    var STATUS  : Bool?
    var DATA    : T?
    
    var access_token : String?
    var error : String?
}
