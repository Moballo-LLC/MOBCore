//
//  MOBDefaultsKeychain.swift
//  KeychainWrapper
//
//  Created by Jason Morcos on 9/23/14.
//  Copyright (c) 2014 Moballo, LLC. All rights reserved.
//

import Foundation

public class MOBDefaultsCloud : NSUbiquitousKeyValueStore {
    public let didChangeExternallyNotification = NSUbiquitousKeyValueStore.didChangeExternallyNotification
    public func setAndSync(string: String, forKey keyName: String) {
        self.set(string, forKey: keyName)
        self.synchronize()
    }
    public func setAndSync(bool: Bool, forKey keyName: String) {
        self.set(bool, forKey: keyName)
        self.synchronize()
    }
    public func setAndSync(integer: Int, forKey keyName: String) {
        self.set(integer, forKey: keyName)
        self.synchronize()
    }
    public func setAndSync(array: Array<Any>, forKey keyName: String) {
        self.set(array, forKey: keyName)
        self.synchronize()
    }
    public func setAndSync(object: NSCoding, forKey keyName: String) {
        self.set(object, forKey: keyName)
        self.synchronize()
    }
    public func addChangeObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: self.didChangeExternallyNotification, object: self)
    }
}
