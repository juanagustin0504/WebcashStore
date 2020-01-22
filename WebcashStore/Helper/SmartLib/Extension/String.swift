//
//  String.swift
//  SmartLib
//
//  Created by God Save The King on 2020/01/08.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    public subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
    
    /// Trim a string
    public func trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Convert a string to Int value, if cannot 0 is returned instead.
    public func toInt() -> Int {
        Int(self) ?? 0
    }
    
    /// Convert a string to double value, if cannot 0 is returned instead.
    public func toDouble() -> Double {
        Double(self) ?? 0
    }
    
    /// Returns a base64 representation of the current string, or nil if the
    /// operation fails.
    public func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    /// Assuming the current string is base64 encoded, this property returns a String
    /// initialized by converting the current string into Unicode characters, encoded to
    /// utf8. If the current string is not base64 encoded, nil is returned instead.
    public func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    /// Return the index of a string,
    /// or nil if the operation fails
    /// - Parameter target: a string which you want to get index
    public func lastIndexOf(target: String) -> Int? {
        if let range = self.range(of: target, options: .backwards, range: nil, locale: nil) {
            return distance(from: self.startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
    
    /// Return range of a string,
    /// or nil if the operation fails
    /// - Parameter target: a string which you want to get range
    public func lastRangeOf(target: String) -> String.Index? {
        if let range = self.range(of: target, options: .backwards, range: nil, locale: nil) {
            return range.lowerBound
        } else {
            return nil
        }
    }
    
    /// Return a character at specific index
    /// - Parameter i: index
    public func characterAtIndex(_ i: Int) -> Character? {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    /// Return a string from range
    /// - Parameters:
    ///   - start: start index
    ///   - end: end index
    func substringWithRange(_ start: Int, end: Int) -> String {
        if (start < 0 || start > self.count) {
            return ""
        }
        else if end < 0 || end > self.count {
            return ""
        }
        let range = (self.index(self.startIndex, offsetBy: start) ..< self.index(self.startIndex, offsetBy: end))
        return String(self[range])
    }
    
    /// Return a dictionary
    /// or nil if the operation fails
    public func toDictionary() -> [String: AnyObject]? {
        if let data = self.data(using: .utf8) {
            do { return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            } catch { print(error.localizedDescription) }
        }
        return nil
    }

    public func formatKRWCurrency() -> String {
        if self.isEmpty { return "" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.currencySymbol = ""
        formatter.locale = Locale(identifier: "en_US")
        
        let format = formatter.string(from: NSNumber(floatLiteral: (self as NSString).doubleValue))!
        return format
    }
    
    /// Return a Date from a string with any format,
    /// or today date if the operation fails
    /// - Parameter format: a format style like "YYYY.MM.dd"
    public func formatToDate(withFormat format: String) -> Date {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = format
        dateFormatter.timeZone      = Calendar.current.timeZone
        dateFormatter.locale        = Calendar.current.locale
        
        return dateFormatter.date(from: self) ?? Date()
    }
    
    /// Return a date string with a new format,
    /// or today date if the operation fails
    /// - Parameters:
    ///   - format: new date format
    ///   - fromFormat: current date format
    public func format(format: String, fromFormat: String = "yyyy-MM-dd") -> String {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = format
        dateFormatter.timeZone      = Calendar.current.timeZone
        dateFormatter.locale        = Calendar.current.locale
        
        let getDate = DateFormatter()
        getDate.dateFormat = fromFormat
        
        return dateFormatter.string(from: getDate.date(from: self) ?? Date())
    }
    
    
    /// URL 인코딩
    public func encodeURL() -> String {
        NSString.urlEncode(self)
    }
    
    /// URL 디코딩
    public func decodeURL() -> String{
        NSString.urlDecode(self)
    }
    
    /// AES256 암호화
    /// - Parameter key: 키
    public func encryptAES256String(withKey key : String) -> String {
        AES256Encryption.encryptAES256String(self, key: key)
    }
    
    /// AES256 decrypt
    /// - Parameter key: 키
    public func decryptAES256String(withKey key : String) -> String {
        AES256Encryption.decrptAES256String(self, key: key)
    }
    
    /// AES128 암호화
    /// - Parameter key: 키
    public func encryptAES128String(withKey key : String) ->  String {
        AES256Encryption.encryptAES128String(self, key: key)
    }
    
    /// AES128 decrypt
    /// - Parameter key: 키
    public func decryptAES128String(withKey key : String) -> String {
        AES256Encryption.decrptAES128String(self, key: key)
    }
    
    mutating func replaced(of: String, with: String) {
        self = self.replacingOccurrences(of: of, with: with)
    }
    
    func replace(of: String, with: String) -> String {
        return self.replacingOccurrences(of: of, with: with)
    }
    
    func remove(of: String) -> String {
        return self.replacingOccurrences(of: of, with: "")
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    var html2String: String {
        guard let data = data(using: .utf8) else { return "" }
        do {
            let attributeString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            return attributeString.string
        } catch let error as NSError {
            print(error.localizedDescription)
            return ""
        }
    }
    
    var html2AttrString: NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            let attributeString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            return attributeString
        } catch let error as NSError {
            print(error.localizedDescription)
            return NSAttributedString()
        }
    }
}
