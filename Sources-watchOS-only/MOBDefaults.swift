//
//  MOBDefaults.swift
//  MOBCore
//
//  Created by Jason Morcos on 12/4/15.
//  Copyright © 2017 Moballo, LLC. All rights reserved.
//

import UIKit

public class MOBDefaults: NSObject {
    internal let localInstance:MOBDefaultsUser
    internal let groupInstance:MOBDefaultsUser?
    internal let cloudInstance:MOBDefaultsCloud?
    internal let groupKey:String?
    internal let keychainKey:String?
    public init(group: String?) {
        //local
        localInstance = MOBDefaultsUser()
        //group
        self.groupKey = group
        if let groupName = group {
            groupInstance = MOBDefaultsUser(suiteName: groupName)
        } else {
            groupInstance = nil
        }
    }
    public func local() -> UserDefaults {
        return localInstance
    }
    public func group() -> UserDefaults? {
        return groupInstance
    }
}
