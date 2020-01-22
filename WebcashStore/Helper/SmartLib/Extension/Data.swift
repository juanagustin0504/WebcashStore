//
//  Data.swift
//  SmartLib
//
//  Created by God Save The King on 1/17/20.
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
    
    /// Convert Data to NSDictionary
    func dataToDic() -> NSDictionary {
        guard let dic: NSDictionary = (try? JSONSerialization.jsonObject(with: self, options: [])) as? NSDictionary else {
            return [:]
        }
        
        return dic
    }
    
    /// Convert Data to String
    func dataToString() -> String? {
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: self, options: [])
            return jsonResponse as? String
        } catch {
            return nil
        }
    }
    
    /// Get Pretty Print String from Data
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

    
    func dataToDecodableObject<O: Decodable>(responseType type : O.Type) -> O? {

        guard let responseObject = try? JSONDecoder().decode(type.self, from: self) else {
            if self.prettyPrint() == "{\n\n}" {
                
                let htmlString = String(data: self, encoding: .utf8) ?? ""
                
                Log.e("""
                    Error Response:
                    \(self.prettyPrint())
                    \(htmlString)
                    """)
            }
            else {
                Log.e("""
                    Error mapping data.
                    Response:
                    \(self.prettyPrint())
                    """)
            }
            return nil
        }
        return responseObject
    }

    
}
