//
//  MOBDefaultsUser.swift
//  MOBCore
//
//  Created by Jason Morcos on 12/4/15.
//  Copyright © 2017 Moballo, LLC. All rights reserved.
//

import UIKit

@objc public class MOBDefaultsUser: UserDefaults {
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
    
    //setup methods with sync
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
    public func set(float: Float, forKey keyName: String) {
        super.set(float, forKey: keyName)
        super.synchronize()
    }
    public func set(url: URL, forKey keyName: String) {
        super.set(url, forKey: keyName)
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
    public override func set(_ bool: Bool, forKey keyName: String) {
        super.set(bool, forKey: keyName)
        super.synchronize()
    }
    public override func set(_ integer: Int, forKey keyName: String) {
        super.set(integer, forKey: keyName)
        super.synchronize()
    }
    public override func set(_ double: Double, forKey keyName: String) {
        super.set(double, forKey: keyName)
        super.synchronize()
    }
    public override func set(_ float: Float, forKey keyName: String) {
        super.set(float, forKey: keyName)
        super.synchronize()
    }
    public override func set(_ url: URL?, forKey keyName: String) {
        super.set(url, forKey: keyName)
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
    //Set Default Value nullable Support
    public func set(string: String?, defaultValue: String?, forKey keyName: String) {
        super.set(string ?? defaultValue, forKey: keyName)
        super.synchronize()
    }
    public func set(bool: Bool?, defaultValue: Bool?, forKey keyName: String) {
        super.set(bool ?? defaultValue, forKey: keyName)
        super.synchronize()
    }
    public func set(integer: Int?, defaultValue: Int?, forKey keyName: String) {
        super.set(integer ?? defaultValue, forKey: keyName)
        super.synchronize()
    }
    public func set(double: Double?, defaultValue: Double?, forKey keyName: String) {
        super.set(double ?? defaultValue, forKey: keyName)
        super.synchronize()
    }
    public func set(url: URL?, defaultValue: URL?, forKey keyName: String) {
        super.set(url ?? defaultValue, forKey: keyName)
        super.synchronize()
    }
    public func set(float: Float?, defaultValue: Float?, forKey keyName: String) {
        super.set(float ?? defaultValue, forKey: keyName)
        super.synchronize()
    }
    public func set(array: Array<Any>?, defaultValue: Array<Any>?, forKey keyName: String) {
        super.set(array ?? defaultValue, forKey: keyName)
        super.synchronize()
    }
    public func set(object: Any?, defaultValue: Any?, forKey keyName: String) {
        super.set(object ?? defaultValue, forKey: keyName)
        super.synchronize()
    }
}

