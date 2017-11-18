//
//  MOBDefaults.swift
//  MOBCore
//
//  Created by Jason Morcos on 12/4/15.
//  Copyright © 2017 Moballo, LLC. All rights reserved.
//

import UIKit

public class MOBDefaults: NSObject {
    @objc internal let localInstance:MOBDefaultsUser
    @objc internal let groupInstance:MOBDefaultsUser?
    #if os(iOS)
    internal let cloudInstance:MOBDefaultsCloud?
    #endif
    
    @objc internal let keychainInstance:MOBDefaultsKeychain?
    @objc internal let groupKey:String?
    @objc internal let keychainKey:String?
    @objc public init(group: String?, keychain: String?) {
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
    @objc public func local() -> MOBDefaultsUser {
        return localInstance
    }
    @objc public func group() -> MOBDefaultsUser? {
        return groupInstance
    }
    #if os(iOS)
    public func cloud() -> MOBDefaultsCloud? {
        return cloudInstance
    }
    #endif
    @objc public func keychain() -> MOBDefaultsKeychain? {
        return keychainInstance
    }
}

