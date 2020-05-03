//
//  MOBDefaultsKeychain.swift
//  MOBCore
//
//  Created by Jason Morcos on 12/4/15.
//  Copyright © 2017 Moballo, LLC. All rights reserved.
//

import Foundation

@objc public class MOBDefaultsKeychain : NSObject {
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
    // MARK: Getting Values
    public func string(forKey keyName: String) -> String? {
        let keychainData: Data? = self.getData(forKey: keyName)
        var stringValue: String?
        if let data = keychainData {
            stringValue = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
            if let trimmedString = stringValue {
                if trimmedString.components(separatedBy: CharacterSet.whitespaces).joined() == "" {
                    return nil
                }
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
        
        return stringValue!
    }
    public func bool(forKey keyName: String) -> Bool? {
        let keychainData: Data? = self.getData(forKey: keyName)
        var boolValue: Bool?
        if let data = keychainData {
            if #available(iOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, *) {
                do { try boolValue = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Bool } catch { boolValue = nil }
            } else {
                boolValue = NSKeyedUnarchiver.unarchiveObject(with: data) as? Bool
            }
        }
        else {
            return nil
        }
        
        return boolValue
    }
    public func integer(forKey keyName: String) -> Int? {
        let keychainData: Data? = self.getData(forKey: keyName)
        var intValue: Int?
        if let data = keychainData {
            if #available(iOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, *) {
                do { try intValue = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Int } catch { intValue = nil }
            } else {
                intValue = NSKeyedUnarchiver.unarchiveObject(with: data) as? Int
            }
        }
        else {
            return nil
        }
        
        return intValue
    }
    public func double(forKey keyName: String) -> Double? {
        let keychainData: Data? = self.getData(forKey: keyName)
        var doubleValue: Double?
        if let data = keychainData {
            if #available(iOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, *) {
                do { try doubleValue = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Double } catch { doubleValue = nil }
            } else {
                doubleValue = NSKeyedUnarchiver.unarchiveObject(with: data) as? Double
            }
        }
        else {
            return nil
        }
        
        return doubleValue
    }
    public func float(forKey keyName: String) -> Float? {
        let keychainData: Data? = self.getData(forKey: keyName)
        var floatValue: Float?
        if let data = keychainData {
            if #available(iOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, *) {
                do { try floatValue = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Float } catch { floatValue = nil }
            } else {
                floatValue = NSKeyedUnarchiver.unarchiveObject(with: data) as? Float
            }
        }
        else {
            return nil
        }
        
        return floatValue
    }
    public func url(forKey keyName: String) -> URL? {
        let keychainData: Data? = self.getData(forKey: keyName)
        var urlValue: URL?
        if let data = keychainData {
            if #available(iOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, *) {
                do { try urlValue = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? URL } catch { urlValue = nil }
            } else {
                urlValue = NSKeyedUnarchiver.unarchiveObject(with: data) as? URL
            }
        }
        else {
            return nil
        }
        
        return urlValue
    }
    public func dictionary(forKey keyName: String) -> [String : Any]? {
        let keychainData: Data? = self.getData(forKey: keyName)
        var dictValue: [String : Any]?
        if let data = keychainData {
            if #available(iOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, *) {
                do { try dictValue = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String : Any] } catch { dictValue = nil }
            } else {
                dictValue = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : Any]
            }
        }
        else {
            return nil
        }
        
        return dictValue
    }
    public func array(forKey keyName: String) -> Array<Any>? {
        let keychainData: Data? = self.getData(forKey: keyName)
        var arrayValue: Array<Any>?
        if let data = keychainData {
            if #available(iOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, *) {
                do { try arrayValue = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<Any> } catch { arrayValue = nil }
            } else {
                arrayValue = NSKeyedUnarchiver.unarchiveObject(with: data) as? Array<Any>
            }
        }
        else {
            return nil
        }
        
        return arrayValue
    }
    public func object(forKey keyName: String) -> Any? {
        let dataValue: Data? = self.getData(forKey: keyName)
        
        var objectValue: Any?
        
        if let data = dataValue {
            if #available(iOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, *) {
                do { try objectValue = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) } catch { objectValue = nil }
            } else {
                objectValue = NSKeyedUnarchiver.unarchiveObject(with: data)
            }
        } else {
            return nil
        }
        
        return objectValue;
    }
    //GET
    fileprivate func getData(forKey keyName: String) -> Data? {
        let keychainQueryDictionary = self.setupKeychainQueryDictionary(forKey: keyName)
        var result: AnyObject?
        
        // Limit search results to one
        keychainQueryDictionary[MOBDefaultsKeychain.SecMatchLimit as Any] = kSecMatchLimitOne
        
        // Specify we want NSData/CFData returned
        keychainQueryDictionary[MOBDefaultsKeychain.SecReturnData as Any] = kCFBooleanTrue
        
        // Search
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(keychainQueryDictionary, UnsafeMutablePointer($0))
        }
        
        return status == noErr ? result as? Data : nil
    }
    
    // MARK: Setting Values
    @discardableResult
    public func set(string: String, forKey keyName: String) -> Bool {
        if let data = string.data(using: String.Encoding.utf8) {
            return self.setData(value: data, forKey: keyName)
        } else {
            return false
        }
    }
    @discardableResult
    public func set(bool: Bool, forKey keyName: String) -> Bool {
        let data: Data
        if #available(iOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, *) {
            do { try data = NSKeyedArchiver.archivedData(withRootObject: bool, requiringSecureCoding: false) } catch { return false }
        } else {
            data = NSKeyedArchiver.archivedData(withRootObject: bool)
        }
        return self.setData(value: data, forKey: keyName)
    }
    @discardableResult
    public func set(integer: Int, forKey keyName: String) -> Bool {
        let data: Data
        if #available(iOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, *) {
            do { try data = NSKeyedArchiver.archivedData(withRootObject: integer, requiringSecureCoding: false) } catch { return false }
        } else {
            data = NSKeyedArchiver.archivedData(withRootObject: integer)
        }
        return self.setData(value: data, forKey: keyName)
    }
    @discardableResult
    public func set(float: Float, forKey keyName: String) -> Bool {
        let data: Data
        if #available(iOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, *) {
            do { try data = NSKeyedArchiver.archivedData(withRootObject: float, requiringSecureCoding: false) } catch { return false }
        } else {
            data = NSKeyedArchiver.archivedData(withRootObject: float)
        }
        return self.setData(value: data, forKey: keyName)
    }
    @discardableResult
    public func set(double: Double, forKey keyName: String) -> Bool {
        let data: Data
        if #available(iOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, *) {
            do { try data = NSKeyedArchiver.archivedData(withRootObject: double, requiringSecureCoding: false) } catch { return false }
        } else {
            data = NSKeyedArchiver.archivedData(withRootObject: double)
        }
        return self.setData(value: data, forKey: keyName)
    }
    @discardableResult
    public func set(url: URL, forKey keyName: String) -> Bool {
        let data: Data
        if #available(iOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, *) {
            do { try data = NSKeyedArchiver.archivedData(withRootObject: url, requiringSecureCoding: false) } catch { return false }
        } else {
            data = NSKeyedArchiver.archivedData(withRootObject: url)
        }
        return self.setData(value: data, forKey: keyName)
    }
    @discardableResult
    public func set(dictionary: [String : Any], forKey keyName: String) -> Bool {
        let data: Data
        if #available(iOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, *) {
            do { try data = NSKeyedArchiver.archivedData(withRootObject: dictionary, requiringSecureCoding: false) } catch { return false }
        } else {
            data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        }
        return self.setData(value: data, forKey: keyName)
    }
    @discardableResult
    public func set(array: Array<Any>, forKey keyName: String) -> Bool {
        let data: Data
        if #available(iOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, *) {
            do { try data = NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false) } catch { return false }
        } else {
            data = NSKeyedArchiver.archivedData(withRootObject: array)
        }
        return self.setData(value: data, forKey: keyName)
    }
    @discardableResult
    public func set(object: Any, forKey keyName: String) -> Bool {
        let data: Data
        if #available(iOS 11.0, watchOS 4.0, iOSApplicationExtension 11.0, *) {
            do { try data = NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false) } catch { return false }
        } else {
            data = NSKeyedArchiver.archivedData(withRootObject: object)
        }
        return self.setData(value: data, forKey: keyName)
    }
    @discardableResult
    fileprivate func setData(value: Data, forKey keyName: String) -> Bool {
        let keychainQueryDictionary: NSMutableDictionary = self.setupKeychainQueryDictionary(forKey: keyName)
        
        keychainQueryDictionary[MOBDefaultsKeychain.SecValueData as Any] = value
        keychainQueryDictionary[MOBDefaultsKeychain.SecAttrAccessGroup as Any] = self.accessGroup
        // Protect the keychain entry so it's only valid when the device is unlocked
        keychainQueryDictionary[MOBDefaultsKeychain.SecAttrAccessible as Any] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        let status: OSStatus = SecItemAdd(keychainQueryDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return self.updateData(value: value, forKey: keyName)
        } else {
            return false
        }
    }
    //Set Default Value Support
    public func set(string: String?, defaultValue: String, forKey keyName: String) {
        self.set(string: string ?? defaultValue, forKey: keyName)
    }
    public func set(bool: Bool?, defaultValue: Bool, forKey keyName: String) {
        self.set(bool: bool ?? defaultValue, forKey: keyName)
    }
    public func set(integer: Int?, defaultValue: Int, forKey keyName: String) {
        self.set(integer: integer ?? defaultValue, forKey: keyName)
    }
    public func set(double: Double?, defaultValue: Double, forKey keyName: String) {
        self.set(double: double ?? defaultValue, forKey: keyName)
    }
    public func set(url: URL?, defaultValue: URL, forKey keyName: String) {
        self.set(url: url ?? defaultValue, forKey: keyName)
    }
    public func set(float: Float?, defaultValue: Float, forKey keyName: String) {
        self.set(float: float ?? defaultValue, forKey: keyName)
    }
    public func set(array: Array<Any>?, defaultValue: Array<Any>, forKey keyName: String) {
        self.set(array: array ?? defaultValue, forKey: keyName)
    }
    public func set(object: Any?, defaultValue: Any, forKey keyName: String) {
        self.set(object: object ?? defaultValue, forKey: keyName)
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
        let keychainQueryDictionary: NSMutableDictionary = [(MOBDefaultsKeychain.SecClass as Any):kSecClassGenericPassword]
        
        // Uniquely identify this keychain accessor
        keychainQueryDictionary[MOBDefaultsKeychain.SecAttrService as Any] = MOBDefaultsKeychain.serviceName
        // Uniquely identify the account who will be accessing the keychain
        let encodedIdentifier: Data? = keyName.data(using: String.Encoding.utf8)
        //     keychainQueryDictionary.setObject(accessGroup!, forKey: kSecAttrAccessGroup as String)
        keychainQueryDictionary[MOBDefaultsKeychain.SecAttrAccessGroup as Any] = accessGroup
        keychainQueryDictionary[MOBDefaultsKeychain.SecAttrGeneric as Any] = encodedIdentifier
        keychainQueryDictionary[MOBDefaultsKeychain.SecAttrAccount as Any] = encodedIdentifier
        return keychainQueryDictionary
    }
    
    
    //Default value
    public func string(forKey keyName: String, defaultValue:String) -> String {
        if let val = self.string(forKey: keyName) as String? {
            return val
        }
        return defaultValue
    }
    public func bool(forKey keyName: String, defaultValue:Bool) -> Bool {
        if let val = self.bool(forKey: keyName) as Bool? {
            return val
        }
        return defaultValue
    }
    public func integer(forKey keyName: String, defaultValue:Int) -> Int {
        if let val = self.integer(forKey: keyName) as Int? {
            return val
        }
        return defaultValue
    }
    public func double(forKey keyName: String, defaultValue:Double) -> Double {
        if let val = self.double(forKey: keyName) as Double? {
            return val
        }
        return defaultValue
    }
    public func float(forKey keyName: String, defaultValue:Float) -> Float {
        if let val = self.float(forKey: keyName) as Float? {
            return val
        }
        return defaultValue
    }
    public func url(forKey keyName: String, defaultValue:URL) -> URL {
        if let val = self.url(forKey: keyName) as URL? {
            return val
        }
        return defaultValue
    }
    public func array(forKey keyName: String, defaultValue:Array<Any>) -> Array<Any> {
        if let val = self.array(forKey: keyName) {
            return val
        }
        return defaultValue
    }
    public func object(forKey keyName: String, defaultValue:Any) -> Any {
        if let val = self.object(forKey: keyName) {
            return val
        }
        return defaultValue
    }
    public func dictionary(forKey keyName: String, defaultValue:[String : Any]) -> [String : Any] {
        if let val = self.dictionary(forKey: keyName) {
            return val
        }
        return defaultValue
    }
    
    //Default value nullable
    public func string(forKey keyName: String, defaultValueNullable:String?) -> String? {
        if let val = self.string(forKey: keyName) as String? {
            return val
        }
        return defaultValueNullable
    }
    public func bool(forKey keyName: String, defaultValueNullable:Bool?) -> Bool? {
        if let val = self.bool(forKey: keyName) as Bool? {
            return val
        }
        return defaultValueNullable
    }
    public func integer(forKey keyName: String, defaultValueNullable:Int?) -> Int? {
        if let val = self.integer(forKey: keyName) as Int? {
            return val
        }
        return defaultValueNullable
    }
    public func double(forKey keyName: String, defaultValueNullable:Double?) -> Double? {
        if let val = self.double(forKey: keyName) as Double? {
            return val
        }
        return defaultValueNullable
    }
    public func float(forKey keyName: String, defaultValueNullable:Float?) -> Float? {
        if let val = self.float(forKey: keyName) as Float? {
            return val
        }
        return defaultValueNullable
    }
    public func url(forKey keyName: String, defaultValueNullable:URL?) -> URL? {
        if let val = self.url(forKey: keyName) as URL? {
            return val
        }
        return defaultValueNullable
    }
    public func array(forKey keyName: String, defaultValueNullable:Array<Any>?) -> Array<Any>? {
        if let val = self.array(forKey: keyName) {
            return val
        }
        return defaultValueNullable
    }
    public func object(forKey keyName: String, defaultValueNullable:Any?) -> Any? {
        if let val = self.object(forKey: keyName) {
            return val
        }
        return defaultValueNullable
    }
    public func dictionary(forKey keyName: String, defaultValueNullable:[String : Any]?) -> [String : Any]? {
        if let val = self.dictionary(forKey: keyName) {
            return val
        }
        return defaultValueNullable
    }
}
