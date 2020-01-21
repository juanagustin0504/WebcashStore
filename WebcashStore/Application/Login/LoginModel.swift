//
//  LoginModel.swift
//  WebcashStore
//
//  Created by kosign webcash on 1/18/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

struct LoginModel {
    struct Request : Encodable {
        let grant_type  :   String
        let username    :   String
        let password    :   String
    }
    
    struct Response : Codable {
        let access_token    :   String
        let token_type      :   String
        let refresh_token   :   String
        let expires_in      :   Int
        let scope           :   String
        let jti             :   String
    }
    
}
