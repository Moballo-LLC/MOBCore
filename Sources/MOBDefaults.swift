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
    internal let cloudInstance:NSUbiquitousKeyValueStore?
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
        cloudInstance = NSUbiquitousKeyValueStore()
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
    public func cloud() -> NSUbiquitousKeyValueStore? {
        return cloudInstance
    }
    public func keychain() -> MOBDefaultsKeychain? {
        return keychainInstance
    }
}
