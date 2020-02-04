//
//  UserDefault.swift
//  WebcashStore
//
//  Created by God Save The King on 2/4/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation


@propertyWrapper
struct UserDefault<T> {
    let key             :   String
    let defaultValue    :   T
    
    init(_ key : String, defaultValue : T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

@propertyWrapper
struct Capitalized {
    
    var wrappedValue: String {
        didSet { wrappedValue = wrappedValue.capitalized }
    }

    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.capitalized
    }
}
