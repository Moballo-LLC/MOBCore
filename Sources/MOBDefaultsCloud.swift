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
    public func setAndSync(double: Double, forKey keyName: String) {
        self.set(double, forKey: keyName)
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
    //default values support
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
        if let val = self.object(forKey: keyName) as! Int? {
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
    public func object(forKey keyName: String, defaultValue:NSCoding) -> NSCoding {
        if let val = self.object(forKey: keyName) as! NSCoding? {
            return val
        }
        return defaultValue
    }
}
