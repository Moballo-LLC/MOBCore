//
//  KeychainWrapper.swift
//  KeychainWrapper
//
//  Created by Jason Rendel on 9/23/14.
//  Copyright (c) 2014 jasonrendel. All rights reserved.
//

import Foundation

let SecMatchLimit: String! = kSecMatchLimit as String
let SecReturnData: String! = kSecReturnData as String
let SecValueData: String! = kSecValueData as String
let SecAttrAccessible: String! = kSecAttrAccessible as String
let SecClass: String! = kSecClass as String
let SecAttrService: String! = kSecAttrService as String
let SecAttrGeneric: String! = kSecAttrGeneric as String
let SecAttrAccount: String! = kSecAttrAccount as String
let SecAttrAccessGroup: String! = kSecAttrAccessGroup  as String
let accessGroup:NSString? = "NKQ4HJ66PX.CBTech.GT"
@objc open class KeychainWrapper : NSObject {
    fileprivate struct internalVars {
        static var serviceName: String = ""
    }
    
    // MARK: Public Properties
    
    /*!
    @var serviceName
    @abstract Used for the kSecAttrService property to uniquely identify this keychain accessor.
    @discussion Service Name will default to the app's bundle identifier if it can
    */
    open class var serviceName: String {
        get {
        if internalVars.serviceName.isEmpty {
        //internalVars.serviceName = NSBundle.mainBundle().bundleIdentifier ?? "SwiftKeychainWrapper"
        internalVars.serviceName = "SwiftKeychainWrapper"
        }
        return internalVars.serviceName
        }
        set(newServiceName) {
            internalVars.serviceName = newServiceName
        }
    }
    
    // MARK: Public Methods
    open class func hasValueForKey(_ key: String) -> Bool {
        let keychainData: Data? = self.dataForKey(key)
        if let _ = keychainData {
            return true
        } else {
            return false
        }
    }
    @discardableResult
    open class func deleteIfEmptyString(_ keyName: String) -> Bool {
        if KeychainWrapper.hasValueForKey(keyName) {
            if (KeychainWrapper.stringForKey(keyName) == ""){
                return KeychainWrapper.removeObjectForKey(keyName)
            }
        }
        return false
    }
    // MARK: Getting Values
    open class func stringForKey(_ keyName: String) -> String {
        let keychainData: Data? = self.dataForKey(keyName)
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
    open class func boolForKey(_ keyName: String) -> Bool {
        let keychainData: Data? = self.dataForKey(keyName)
        var boolValue: Bool?
        if let data = keychainData {
            boolValue = NSKeyedUnarchiver.unarchiveObject(with: data) as! Bool?
        }
        else {
            return false
        }
        
        return boolValue!
    }
    open class func intForKey(_ keyName: String) -> Int {
        let keychainData: Data? = self.dataForKey(keyName)
        var intValue: Int?
        if let data = keychainData {
            intValue = NSKeyedUnarchiver.unarchiveObject(with: data) as! Int?
        }
        else {
            return 0
        }
        
        return intValue!
    }
    open class func objectForKey(_ keyName: String) -> NSCoding? {
        let dataValue: Data? = self.dataForKey(keyName)
        
        var objectValue: NSCoding?
        
        if let data = dataValue {
            objectValue = NSKeyedUnarchiver.unarchiveObject(with: data) as! NSCoding?
        }
        
        return objectValue;
    }
    
    @objc func boolForKeyObjC(_ keyName: String) -> String {
        let dataValue: Data? = KeychainWrapper.dataForKey(keyName)
        
        var objectValue: Bool?
        
        if let data = dataValue {
            objectValue = NSKeyedUnarchiver.unarchiveObject(with: data) as! Bool?
        }
        if (objectValue == true) {
            return "YES";
        }
        
        return "NO";
    }
    open class func dataForKey(_ keyName: String) -> Data? {
        let keychainQueryDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        var result: AnyObject?
        
        // Limit search results to one
        keychainQueryDictionary[SecMatchLimit] = kSecMatchLimitOne
        
        // Specify we want NSData/CFData returned
        keychainQueryDictionary[SecReturnData] = kCFBooleanTrue
        
        // Search
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(keychainQueryDictionary, UnsafeMutablePointer($0))
        }
        
        return status == noErr ? result as? Data : nil
    }
    
    // MARK: Setting Values
    @discardableResult
    open class func setString(_ value: String, forKey keyName: String) -> Bool {
        if let data = value.data(using: String.Encoding.utf8) {
            return self.setData(data, forKey: keyName)
        } else {
            return false
        }
    }
    @discardableResult
    open class func setBool(_ value: Bool, forKey keyName: String) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        return self.setData(data, forKey: keyName)
    }
    @discardableResult
    open class func setInt(_ value: Int, forKey keyName: String) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        return self.setData(data, forKey: keyName)
    }
    @discardableResult
    open class func setObject(_ value: NSCoding, forKey keyName: String) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        return self.setData(data, forKey: keyName)
    }
    @discardableResult
    open class func setData(_ value: Data, forKey keyName: String) -> Bool {
        let keychainQueryDictionary: NSMutableDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        
        keychainQueryDictionary[SecValueData] = value
        keychainQueryDictionary[SecAttrAccessGroup] = accessGroup
        // Protect the keychain entry so it's only valid when the device is unlocked
        keychainQueryDictionary[SecAttrAccessible] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        let status: OSStatus = SecItemAdd(keychainQueryDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return self.updateData(value, forKey: keyName)
        } else {
            return false
        }
    }
    
    // MARK: Removing Values
    @discardableResult
    open class func removeObjectForKey(_ keyName: String) -> Bool {
        let keychainQueryDictionary: NSMutableDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        
        // Delete
        let status: OSStatus =  SecItemDelete(keychainQueryDictionary);
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    // MARK: Private Methods
    fileprivate class func updateData(_ value: Data, forKey keyName: String) -> Bool {
        let keychainQueryDictionary: NSMutableDictionary = self.setupKeychainQueryDictionaryForKey(keyName)
        let updateDictionary = [SecValueData:value]
        //keychainQueryDictionary[SecAttrAccessible] = kSecAttrAccessibleAlways
        //keychainQueryDictionary[SecAttrAccessible] = kSecAttrAccessibleAlways
        // Update
        let status: OSStatus = SecItemUpdate(keychainQueryDictionary, updateDictionary as CFDictionary)
        let updateDictionaryAccess = [SecAttrAccessible:kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly]
        SecItemUpdate(keychainQueryDictionary, updateDictionaryAccess as CFDictionary)
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    fileprivate class func setupKeychainQueryDictionaryForKey(_ keyName: String) -> NSMutableDictionary {
        // Setup dictionary to access keychain and specify we are using a generic password (rather than a certificate, internet password, etc)
        let keychainQueryDictionary: NSMutableDictionary = [SecClass:kSecClassGenericPassword]
        
        // Uniquely identify this keychain accessor
        keychainQueryDictionary[SecAttrService] = KeychainWrapper.serviceName
        // Uniquely identify the account who will be accessing the keychain
        let encodedIdentifier: Data? = keyName.data(using: String.Encoding.utf8)
        //     keychainQueryDictionary.setObject(accessGroup!, forKey: kSecAttrAccessGroup as String)
        keychainQueryDictionary[SecAttrAccessGroup] = accessGroup
        keychainQueryDictionary[SecAttrGeneric] = encodedIdentifier
        keychainQueryDictionary[SecAttrAccount] = encodedIdentifier
        return keychainQueryDictionary
    }
}
