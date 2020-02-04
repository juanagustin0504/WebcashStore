//
//  RandomKeyGenerator.swift
//  WebcashStore
//
//  Created by God Save The King on 1/31/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

struct RandomKeyGenerator {

    /// 랜덤 문자열을 생성합니다.
    /// - Parameter length: length of key to generate
    static func getRandomKey(length: Int) -> String {
        // 0 ~ 9
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        var strResult  = ""
        
        if length > 0 {
            for _ in 0...length - 1 {
                let index = arc4random() % UInt32(characters.count)
                let start = characters.index(characters.startIndex, offsetBy: Int(index))
                let end = characters.index(characters.startIndex, offsetBy: Int(index+1))
                let range = start..<end
                strResult += characters[range]
            }
        }
        
        return strResult
    }
}
