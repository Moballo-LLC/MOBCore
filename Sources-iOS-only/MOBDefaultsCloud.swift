//
//  MOBDefaultsCloud.swift
//  MOBCore
//
//  Created by Jason Morcos on 12/4/15.
//  Copyright © 2017 Moballo, LLC. All rights reserved.
//

import Foundation

public class MOBDefaultsCloud : NSUbiquitousKeyValueStore {
    public let didChangeExternallyNotification = NSUbiquitousKeyValueStore.didChangeExternallyNotification
    public func set(string: String, forKey keyName: String) {
        super.set(string, forKey: keyName)
        super.synchronize()
    }
    public func set(bool: Bool, forKey keyName: String) {
        super.set(bool, forKey: keyName)
        super.synchronize()
    }
    public func set(integer: Int, forKey keyName: String) {
        super.set(integer, forKey: keyName)
        super.synchronize()
    }
    public func set(double: Double, forKey keyName: String) {
        super.set(double, forKey: keyName)
        super.synchronize()
    }
    public func set(array: Array<Any>, forKey keyName: String) {
        super.set(array, forKey: keyName)
        super.synchronize()
    }
    public func set(object: Any, forKey keyName: String) {
        super.set(object, forKey: keyName)
        super.synchronize()
    }
    public func set(dictionary: [String : Any], forKey keyName: String) {
        super.set(dictionary, forKey: keyName)
        super.synchronize()
    }
    //override superclass methods
    public override func set(_ string: String?, forKey keyName: String) {
        super.set(string, forKey: keyName)
        super.synchronize()
    }
    public override func set(_ bool: Bool, forKey keyName: String) {
        super.set(bool, forKey: keyName)
        super.synchronize()
    }
    public func set(_ integer: Int, forKey keyName: String) {
        super.set(integer, forKey: keyName)
        super.synchronize()
    }
    public override func set(_ double: Double, forKey keyName: String) {
        super.set(double, forKey: keyName)
        super.synchronize()
    }
    public override func set(_ array: Array<Any>?, forKey keyName: String) {
        super.set(array, forKey: keyName)
        super.synchronize()
    }
    public override func set(_ object: Any?, forKey keyName: String) {
        super.set(object, forKey: keyName)
        super.synchronize()
    }
    public override func removeObject(forKey keyName: String) {
        super.removeObject(forKey: keyName)
        super.synchronize()
    }
    //observer support
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
        if let val = self.integer(forKey: keyName) {
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
    public func object(forKey keyName: String, defaultValue:Any) -> Any? {
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
    //
    //normal values support
    public override func string(forKey keyName: String) -> String? {
        return super.string(forKey: keyName)
    }
    public override func bool(forKey keyName: String) -> Bool {
        return super.bool(forKey: keyName)
    }
    public func integer(forKey keyName: String) -> Int? {
        return super.object(forKey: keyName) as! Int?
    }
    public override func double(forKey keyName: String) -> Double {
        return super.double(forKey: keyName)
    }
    public override func array(forKey keyName: String) -> Array<Any>? {
        return super.array(forKey: keyName)
    }
    public override func object(forKey keyName: String) -> Any? {
        return super.object(forKey: keyName)
    }
    public override func dictionary(forKey keyName: String) -> [String : Any]? {
        return super.dictionary(forKey: keyName)
    }
}
