//
//  Constant.swift
//  WebcashStore
//
//  Created by 위차이 on 1/17/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation
import UIKit

enum APIKey : String {
    static var baseURL = "http://10.254.243.243:8080/webcashstore/"
    static var AuthKey = "Basic a29zaWduLWNsaWVudDprb3NpZ24tc2VjcmV0"
    
    case PreLogin           
    case Token                  =   "oauth/token"
    case KS_SIGNUP              =   "KS_SIGNUP"
    case KS_WEB_MAIN            =   "API/KS_WEB_MAIN"
    case KS_WEB_SEARCH          =   "API/KS_WEB_SEARCH"
    case KS_IOS_MAIN            =   "API/KS_IOS_MAIN"
    case KS_IOS_SEARCH          =   "API/KS_IOS_SEARCH"
    case KS_IOS_UPLOAD          =   "API/KS_IOS_UPLOAD"
    case KS_CHECK_APPNAME       =   "API/KS_CHECK_APPNAME"
    case KS_DELETE              =   "API/KS_DELETE"
    case KS_PUSH_NOTIFICATION   =   "API/KS_PUSH_NOTIFICATION"
    case UploadFile             =   "API/uploadFile"
}

struct AppUtil {
    var AppDelegate : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate;
    }
}
