//
//  MainModel.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/20/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

struct MainModel {
    struct Request : Encodable {
        
    }
    
    
    struct Response : Decodable {
        let app_image : String?
        let app_id : String?
        let app_name : String?
        let ios : [iOS]?
        
        struct iOS : Decodable {
            let version     : String?
            let description : String?
            let develop     : Develop?
            let real        : Real?
            
            struct Develop : Decodable {
                let date    : Double?
                let path    : String?
                let view_count  : Int?
            }
            
            struct Real : Decodable {
                let date    : Double?
                let path    : String?
                let view_count  : Int?
            }
        }
        
    }
    
}
