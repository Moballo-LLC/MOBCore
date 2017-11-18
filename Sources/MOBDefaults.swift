//
//  MOBDefaults.swift
//  MOBCore
//
//  Created by Jason Morcos on 12/4/15.
//  Copyright © 2017 Moballo, LLC. All rights reserved.
//

import UIKit

@objc public class MOBDefaults: NSObject {
    internal let localInstance:MOBDefaultsUser
    internal let groupInstance:MOBDefaultsUser?
    #if os(iOS)
    internal let cloudInstance:MOBDefaultsCloud?
    #endif
    
    internal let keychainInstance:MOBDefaultsKeychain?
    internal let groupKey:String?
    internal let keychainKey:String?
    public init(group: String?, keychain: String?) {
        //local
        localInstance = MOBDefaultsUser()
        //group
        self.groupKey = group
        if let groupName = group {
            groupInstance = MOBDefaultsUser(suiteName: groupName)
        } else {
            groupInstance = nil
        }
        //Keychain
        self.keychainKey = keychain
        if let keychainName = keychain {
            keychainInstance = MOBDefaultsKeychain(accessGroup: keychainName)
        } else {
            keychainInstance = nil
        }
        //cloud
        #if os(iOS)
            cloudInstance = MOBDefaultsCloud()
        #endif
    }
    public func local() -> MOBDefaultsUser {
        return localInstance
    }
    public func group() -> MOBDefaultsUser? {
        return groupInstance
    }
    #if os(iOS)
    public func cloud() -> MOBDefaultsCloud? {
        return cloudInstance
    }
    #endif
    public func keychain() -> MOBDefaultsKeychain? {
        return keychainInstance
    }
}

