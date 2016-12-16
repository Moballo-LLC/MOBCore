//
//  MOBDefaultsKeychain.swift
//  KeychainWrapper
//
//  Created by Jason Morcos on 9/23/14.
//  Copyright (c) 2014 Moballo, LLC. All rights reserved.
//

import Foundation

public class MOBDefaultsKeychain : NSObject {
    fileprivate static let SecMatchLimit: String! = kSecMatchLimit as String
    fileprivate static let SecReturnData: String! = kSecReturnData as String
    fileprivate static let SecValueData: String! = kSecValueData as String
    fileprivate static let SecAttrAccessible: String! = kSecAttrAccessible as String
    fileprivate static let SecClass: String! = kSecClass as String
    fileprivate static let SecAttrService: String! = kSecAttrService as String
    fileprivate static let SecAttrGeneric: String! = kSecAttrGeneric as String
    fileprivate static let SecAttrAccount: String! = kSecAttrAccount as String
    fileprivate static let SecAttrAccessGroup: String! = kSecAttrAccessGroup  as String
    internal var accessGroup:NSString
    fileprivate static var serviceName: String = "SwiftKeychainWrapper"
    public init(accessGroup: String) {
        self.accessGroup = accessGroup as NSString;
    }
    
    // MARK: Public Methods
    public func hasValue(forKey key: String) -> Bool {
        let keychainData: Data? = self.getData(forKey: key)
        if let _ = keychainData {
            return true
        } else {
            return false
        }
    }
    @discardableResult
    public func deleteIfEmptyString(forKey keyName: String) -> Bool {
        if self.hasValue(forKey: keyName) {
            if (self.string(forKey: keyName) == ""){
                return self.removeObject(forKey:  keyName)
            }
        }
        return false
    }
    // MARK: Getting Values
    public func string(forKey keyName: String) -> String {
        let keychainData: Data? = self.getData(forKey: keyName)
        var stringValue: String?
        if let data = keychainData {
            stringValue = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
            if let trimmedString = stringValue {
                if trimmedString.trimmingCharacters(in: CharacterSet.whitespaces) as String! == "" {
                    return ""
                }
            }
            else {
                return ""
            }
        }
        else {
            return ""
        }
        
        return stringValue!
    }
    public func bool(forKey keyName: String) -> Bool {
        let keychainData: Data? = self.getData(forKey: keyName)
        var boolValue: Bool?
        if let data = keychainData {
            boolValue = NSKeyedUnarchiver.unarchiveObject(with: data) as! Bool?
        }
        else {
            return false
        }
        
        return boolValue!
    }
    public func integer(forKey keyName: String) -> Int {
        let keychainData: Data? = self.getData(forKey: keyName)
        var intValue: Int?
        if let data = keychainData {
            intValue = NSKeyedUnarchiver.unarchiveObject(with: data) as! Int?
        }
        else {
            return 0
        }
        
        return intValue!
    }
    public func object(forKey keyName: String) -> NSCoding? {
        let dataValue: Data? = self.getData(forKey: keyName)
        
        var objectValue: NSCoding?
        
        if let data = dataValue {
            objectValue = NSKeyedUnarchiver.unarchiveObject(with: data) as! NSCoding?
        }
        
        return objectValue;
    }
    fileprivate func getData(forKey keyName: String) -> Data? {
        let keychainQueryDictionary = self.setupKeychainQueryDictionary(forKey: keyName)
        var result: AnyObject?
        
        // Limit search results to one
        keychainQueryDictionary[MOBDefaultsKeychain.SecMatchLimit] = kSecMatchLimitOne
        
        // Specify we want NSData/CFData returned
        keychainQueryDictionary[MOBDefaultsKeychain.SecReturnData] = kCFBooleanTrue
        
        // Search
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(keychainQueryDictionary, UnsafeMutablePointer($0))
        }
        
        return status == noErr ? result as? Data : nil
    }
    
    // MARK: Setting Values
    @discardableResult
    public func set(value: String, forKey keyName: String) -> Bool {
        if let data = value.data(using: String.Encoding.utf8) {
            return self.setData(value: data, forKey: keyName)
        } else {
            return false
        }
    }
    @discardableResult
    public func set(bool: Bool, forKey keyName: String) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: bool)
        return self.setData(value: data, forKey: keyName)
    }
    @discardableResult
    public func set(integer: Int, forKey keyName: String) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: integer)
        return self.setData(value: data, forKey: keyName)
    }
    @discardableResult
    public func set(object: NSCoding, forKey keyName: String) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        return self.setData(value: data, forKey: keyName)
    }
    @discardableResult
    fileprivate func setData(value: Data, forKey keyName: String) -> Bool {
        let keychainQueryDictionary: NSMutableDictionary = self.setupKeychainQueryDictionary(forKey: keyName)
        
        keychainQueryDictionary[MOBDefaultsKeychain.SecValueData] = value
        keychainQueryDictionary[MOBDefaultsKeychain.SecAttrAccessGroup] = self.accessGroup
        // Protect the keychain entry so it's only valid when the device is unlocked
        keychainQueryDictionary[MOBDefaultsKeychain.SecAttrAccessible] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        let status: OSStatus = SecItemAdd(keychainQueryDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return self.updateData(value: value, forKey: keyName)
        } else {
            return false
        }
    }
    
    // MARK: Removing Values
    @discardableResult
    public func removeObject(forKey keyName: String) -> Bool {
        let keychainQueryDictionary: NSMutableDictionary = self.setupKeychainQueryDictionary(forKey: keyName)
        
        // Delete
        let status: OSStatus =  SecItemDelete(keychainQueryDictionary);
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    // MARK: Private Methods
    fileprivate func updateData(value: Data, forKey keyName: String) -> Bool {
        let keychainQueryDictionary: NSMutableDictionary = self.setupKeychainQueryDictionary(forKey: keyName)
        let updateDictionary = [MOBDefaultsKeychain.SecValueData:value]
        //keychainQueryDictionary[SecAttrAccessible] = kSecAttrAccessibleAlways
        //keychainQueryDictionary[SecAttrAccessible] = kSecAttrAccessibleAlways
        // Update
        let status: OSStatus = SecItemUpdate(keychainQueryDictionary, updateDictionary as CFDictionary)
        let updateDictionaryAccess = [MOBDefaultsKeychain.SecAttrAccessible:kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly]
        SecItemUpdate(keychainQueryDictionary, updateDictionaryAccess as CFDictionary)
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    internal func setupKeychainQueryDictionary(forKey keyName: String) -> NSMutableDictionary {
        // Setup dictionary to access keychain and specify we are using a generic password (rather than a certificate, internet password, etc)
        let keychainQueryDictionary: NSMutableDictionary = [MOBDefaultsKeychain.SecClass:kSecClassGenericPassword]
        
        // Uniquely identify this keychain accessor
        keychainQueryDictionary[MOBDefaultsKeychain.SecAttrService] = MOBDefaultsKeychain.serviceName
        // Uniquely identify the account who will be accessing the keychain
        let encodedIdentifier: Data? = keyName.data(using: String.Encoding.utf8)
        //     keychainQueryDictionary.setObject(accessGroup!, forKey: kSecAttrAccessGroup as String)
        keychainQueryDictionary[MOBDefaultsKeychain.SecAttrAccessGroup] = accessGroup
        keychainQueryDictionary[MOBDefaultsKeychain.SecAttrGeneric] = encodedIdentifier
        keychainQueryDictionary[MOBDefaultsKeychain.SecAttrAccount] = encodedIdentifier
        return keychainQueryDictionary
    }
}
