//
//  Data.swift
//  SmartLib
//
//  Created by kosign webcash on 1/17/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

extension Data {
    
    public func AES256EncryptWithKey(key : String) -> Data {
        NSData(data: self).aes256Encrypt(withKey: key)
    }
    
    public func AES256DecryptWithKey(key : String) -> Data {
        NSData(data: self).aes256Decrypt(withKey: key)
    }
    
    public func dataWithBase64EncodedString(plainStr str : String) -> Data {
        NSData(base64EncodedString: str) as Data
    }
    
    public func base64Encoding() -> String {
        NSData(data: self).base64Encoding(withLineLength: 0)
    }
    
    public func base64EncodingWithLineLength(length : UInt) -> String {
        NSData(data: self).base64Encoding(withLineLength: length)
    }
    
    public func AES128EncryptedDataWithKey(key : String) -> Data {
        NSData(data: self).aes128EncryptedData(withKey: key)
    }
    
    public func AES128EncryptedDataWithKey(key : String, andIV iv : String) -> Data {
        NSData(data: self).aes128EncryptedData(withKey: key, iv: iv)
    }
    
    public func AES128DecryptedDataWithKey(key : String) -> Data {
        NSData(data: self).aes128DecryptedData(withKey: key)
    }
    
    public func AES128DecryptedDataWithKey(key : String, andIV iv : String) -> Data {
        NSData(data: self).aes128DecryptedData(withKey: key, iv: iv)
    }
    
    func dataToDic() -> NSDictionary {
        guard let dic: NSDictionary = (try? JSONSerialization.jsonObject(with: self, options: [])) as? NSDictionary else {
            return [:]
        }
        
        return dic
    }
    
    func prettyPrint() -> String {
        if JSONSerialization.isValidJSONObject(self.dataToDic()) {
            if let data = try? JSONSerialization.data(withJSONObject: self.dataToDic(), options: JSONSerialization.WritingOptions.prettyPrinted) {
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }
        }
        return ""
    }
    
    
}
