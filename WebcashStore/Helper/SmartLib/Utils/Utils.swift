//
//  Utils.swift
//  WebcashStore
//
//  Created by God Save The King on 1/31/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation
import UIKit

struct ObjUtils {
    
    /// //보안키패드 보안키 값 가져오기
    /// - Parameter keyString: key string
    static func getSecureKey(keyString : String) -> Data {
        Data(bytes: keyString.cString(using: .utf8)!, count: 16)
    }
}

struct AppUtil {
    static var AppDelegate : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate;
    }
    
    static var window : UIWindow? {
        UIApplication.shared.keyWindow
    }
}


struct Secure {
    let secureKey : String!
    
    func getSecureKeyData() -> Data? {
        guard let hexKey = NSString().sha256inputString(self.secureKey) else {
            return nil
        }
        return ObjUtils.getSecureKey(keyString: hexKey)
    }
}
