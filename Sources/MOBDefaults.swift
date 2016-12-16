//
//  MOBDefaults.swift
//  MOBAdvertising
//
//  Created by Jason Morcos on 11/23/16.
//  Copyright © 2016 CBTech. All rights reserved.
//

import UIKit

public class MOBDefaults: NSObject {
    internal let: localInstance:UserDefaults
    internal let: groupInstance:UserDefaults
    internal let: cloudInstance:NSUbiquitousKeyValueStore?
    internal let: keychainInstance:MOBDefaultsKeychain?
    internal let group:String?
    internal let keychain:string?
    public init(group: String?, keychain: String?) {
        self.group = group
        self.keychain = keychain
        localInstance = UserDefaults.standard
        if let groupName = group {
            groupInstance = UserDefaults(suiteName: groupName)
        }
        cloudInstance = NSUbiquitousKeyValueStore()
        if let keychainName = keychain {
            groupInstance = MOBDefaultsKeychain(accessGroup: keychain)
        }
    }
    public func local() -> UserDefaults {
        return localInstance!
    }
    public func group() -> UserDefaults {
        return groupInstance!
        //return UserDefaults(suiteName: "group.gtportal")
    }
    public func cloud() -> NSUbiquitousKeyValueStore {
        return cloudInstance!
    }
    public func keychain() -> MOBDefaultsKeychain {
        return keychainInstance!
        //let accessGroup:NSString? = "NKQ4HJ66PX.CBTech.GT"
        //FIX THAT
    }
}

