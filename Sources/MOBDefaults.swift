//
//  MOBDefaults.swift
//  MOBAdvertising
//
//  Created by Jason Morcos on 11/23/16.
//  Copyright © 2016 CBTech. All rights reserved.
//

import UIKit

public class MOBDefaults: NSObject {
    internal let localInstance:UserDefaults
    internal let groupInstance:UserDefaults?
    internal let cloudInstance:MOBDefaultsCloud?
    internal let keychainInstance:MOBDefaultsKeychain?
    internal let groupKey:String?
    internal let keychainKey:String?
    public init(group: String?, keychain: String?) {
        self.groupKey = group
        self.keychainKey = keychain
        localInstance = UserDefaults.standard
        if let groupName = group {
            groupInstance = UserDefaults(suiteName: groupName)
        } else {
            groupInstance = nil
        }
        cloudInstance = MOBDefaultsCloud()
        if let keychainName = keychain {
            keychainInstance = MOBDefaultsKeychain(accessGroup: keychainName)
        } else {
            keychainInstance = nil
        }
    }
    public func local() -> UserDefaults {
        return localInstance
    }
    public func group() -> UserDefaults? {
        return groupInstance
    }
    public func cloud() -> MOBDefaultsCloud? {
        return cloudInstance
    }
    public func keychain() -> MOBDefaultsKeychain? {
        return keychainInstance
    }
}
extension UserDefaults {
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
}
