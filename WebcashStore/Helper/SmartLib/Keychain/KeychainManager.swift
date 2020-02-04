//
//  KeychainManager.swift
//  WebcashStore
//
//  Created by God Save The King on 2/4/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation

struct KeychainManager {
    
    //MARK: - private properties
    private init() {}
    private static let keychain = KeychainSwift()
    
    //MARK: - static functions
    
    /// Specifies whether the items can be synchronized with other devices through iCloud. Setting this property to `true` will add the item to other devices with the `set` method and obtain synchronizable items with the `get` command.
    /// Deleting synchronizable items will remove them from all devices.
    /// In order for keychain synchronization to work the user must enable "Keychain" in iCloud settings.
    /// - Parameter syn: True / False
    static func setSynchronizable(isSynchronizable syn : Bool = false) {
        Self.keychain.synchronizable = syn
    }
    
    /// Access Group
    /// Sharing keychain items with other apps
    /// Use accessGroup to access shared keychain items
    /// - Parameter group: group name
    static func setAccessGroup(group : String) {
        Self.keychain.accessGroup = group
    }
    
    /// Stores the String value in the keychain item under the given key.
    /// - Parameters:
    ///   - key: Key under which the value is stored in the keychain.
    ///   - val: String to be written to the keychain.
    static func setString(key : KeychainKey, andValue val: String) {
        Self.keychain.set(val, forKey: key.rawValue)
    }
    
    /// Retrieves the String value from the keychain that corresponds to the given key.
    /// - Parameter key: The key that is used to read the keychain item.
    static func getString(from key : KeychainKey) -> String? {
        Self.keychain.get(key.rawValue) ?? nil
    }
    
    /// Stores the Boolean value in the keychain item under the given key.
    /// - Parameters:
    ///   - key: Key under which the value is stored in the keychain.
    ///   - val: Boolean to be written to the keychain.
    static func setBool(key : KeychainKey, andValue val: Bool) {
        Self.keychain.set(val, forKey: key.rawValue)
    }
    /// Retrieves the Boolean value from the keychain that corresponds to the given key.
    /// - Parameter key: The key that is used to read the keychain item.
    static func getBool(from key : KeychainKey) -> Bool? {
        Self.keychain.getBool(key.rawValue) ?? nil
    }
    
    /// Stores the Data value in the keychain item under the given key.
    /// - Parameters:
    ///   - key: Key under which the value is stored in the keychain.
    ///   - val: Data to be written to the keychain.
    static func setData(key : KeychainKey, andValue val: Data) {
        Self.keychain.set(val, forKey: key.rawValue)
    }
    /// Retrieves the Data value from the keychain that corresponds to the given key.
    /// - Parameter key: The key that is used to read the keychain item.
    static func getData(from key : KeychainKey) -> Data? {
        Self.keychain.getData(key.rawValue) ?? nil
    }
    
    /// Remove the single keychain item specified by the key.
    /// - Parameter key: The key that is used to delete the keychain item.
    @discardableResult
    static func remove(from key : KeychainKey) -> Bool {
        Self.keychain.delete(key.rawValue)
    }
    
    /// Delete everything from app's Keychain
    @discardableResult
    static func removeAll() -> Bool {
        Self.keychain.clear()
    }
    
    /// Return all keys from keychain
    static func getAllKeys() -> [String] {
        Self.keychain.allKeys
    }
}

enum KeychainKey : String {
    case UserID     =   "UserID"
    case Password   =   "Password"
}
