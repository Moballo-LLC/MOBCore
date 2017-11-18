//
//  MOBDefaultsUser.swift
//  MOBCore
//
//  Created by Jason Morcos on 12/4/15.
//  Copyright © 2017 Moballo, LLC. All rights reserved.
//

import UIKit

public class MOBDefaultsUser: UserDefaults {
    //Default value
    @objc public func string(forKey keyName: String, defaultValue:String) -> String {
        if let val = self.string(forKey: keyName) as String? {
            return val
        }
        return defaultValue
    }
    @objc public func bool(forKey keyName: String, defaultValue:Bool) -> Bool {
        if let val = self.bool(forKey: keyName) as Bool? {
            return val
        }
        return defaultValue
    }
    @objc public func integer(forKey keyName: String, defaultValue:Int) -> Int {
        if let val = self.integer(forKey: keyName) as Int? {
            return val
        }
        return defaultValue
    }
    @objc public func double(forKey keyName: String, defaultValue:Double) -> Double {
        if let val = self.double(forKey: keyName) as Double? {
            return val
        }
        return defaultValue
    }
    @objc public func float(forKey keyName: String, defaultValue:Float) -> Float {
        if let val = self.float(forKey: keyName) as Float? {
            return val
        }
        return defaultValue
    }
    @objc public func url(forKey keyName: String, defaultValue:URL) -> URL {
        if let val = self.url(forKey: keyName) as URL? {
            return val
        }
        return defaultValue
    }
    @objc public func array(forKey keyName: String, defaultValue:Array<Any>) -> Array<Any> {
        if let val = self.array(forKey: keyName) {
            return val
        }
        return defaultValue
    }
    @objc public func object(forKey keyName: String, defaultValue:Any) -> Any {
        if let val = self.object(forKey: keyName) {
            return val
        }
        return defaultValue
    }
    @objc public func dictionary(forKey keyName: String, defaultValue:[String : Any]) -> [String : Any] {
        if let val = self.dictionary(forKey: keyName) {
            return val
        }
        return defaultValue
    }
    
    //Default value nullable
    public func string(forKey keyName: String, defaultValue defaultValueNullable:String?) -> String? {
        if let val = self.string(forKey: keyName) as String? {
            return val
        }
        return defaultValueNullable
    }
    public func bool(forKey keyName: String, defaultValue defaultValueNullable:Bool?) -> Bool? {
        if let val = self.bool(forKey: keyName) as Bool? {
            return val
        }
        return defaultValueNullable
    }
    public func integer(forKey keyName: String, defaultValue defaultValueNullable:Int?) -> Int? {
        if let val = self.integer(forKey: keyName) as Int? {
            return val
        }
        return defaultValueNullable
    }
    public func double(forKey keyName: String, defaultValue defaultValueNullable:Double?) -> Double? {
        if let val = self.double(forKey: keyName) as Double? {
            return val
        }
        return defaultValueNullable
    }
    public func float(forKey keyName: String, defaultValue defaultValueNullable:Float?) -> Float? {
        if let val = self.float(forKey: keyName) as Float? {
            return val
        }
        return defaultValueNullable
    }
    public func url(forKey keyName: String, defaultValue defaultValueNullable:URL?) -> URL? {
        if let val = self.url(forKey: keyName) as URL? {
            return val
        }
        return defaultValueNullable
    }
    public func array(forKey keyName: String, defaultValue defaultValueNullable:Array<Any>?) -> Array<Any>? {
        if let val = self.array(forKey: keyName) {
            return val
        }
        return defaultValueNullable
    }
    public func object(forKey keyName: String, defaultValue defaultValueNullable:Any?) -> Any? {
        if let val = self.object(forKey: keyName) {
            return val
        }
        return defaultValueNullable
    }
    public func dictionary(forKey keyName: String, defaultValue defaultValueNullable:[String : Any]?) -> [String : Any]? {
        if let val = self.dictionary(forKey: keyName) {
            return val
        }
        return defaultValueNullable
    }
    
    //setup methods with sync
    @objc public func set(string: String, forKey keyName: String) {
        super.set(string, forKey: keyName)
        super.synchronize()
    }
    @objc public func set(bool: Bool, forKey keyName: String) {
        super.set(bool, forKey: keyName)
        super.synchronize()
    }
    @objc public func set(integer: Int, forKey keyName: String) {
        super.set(integer, forKey: keyName)
        super.synchronize()
    }
    @objc public func set(double: Double, forKey keyName: String) {
        super.set(double, forKey: keyName)
        super.synchronize()
    }
    @objc public func set(float: Float, forKey keyName: String) {
        super.set(float, forKey: keyName)
        super.synchronize()
    }
    @objc public func set(url: URL, forKey keyName: String) {
        super.set(url, forKey: keyName)
        super.synchronize()
    }
    @objc public func set(array: Array<Any>, forKey keyName: String) {
        super.set(array, forKey: keyName)
        super.synchronize()
    }
    @objc public func set(object: Any, forKey keyName: String) {
        super.set(object, forKey: keyName)
        super.synchronize()
    }
    @objc public func set(dictionary: [String : Any], forKey keyName: String) {
        super.set(dictionary, forKey: keyName)
        super.synchronize()
    }
    //override superclass methods
    @objc public func set(_ string: String, forKey keyName: String) {
        super.set(string, forKey: keyName)
        super.synchronize()
    }
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
    public func set(_ url: URL, forKey keyName: String) {
        self.set(url, forKey: keyName)
    }
    public override func set(_ object: Any?, forKey keyName: String) {
        super.set(object, forKey: keyName)
        super.synchronize()
    }
    public override func removeObject(forKey keyName: String) {
        super.removeObject(forKey: keyName)
        super.synchronize()
    }
    //Set Default Value Support
    public func set(_ string: String?, defaultValue: String, forKey keyName: String) {
        self.set(string ?? defaultValue, forKey: keyName)
    }
    public func set(_ bool: Bool?, defaultValue: Bool, forKey keyName: String) {
        self.set(bool ?? defaultValue, forKey: keyName)
    }
    public func set(_ integer: Int?, defaultValue: Int, forKey keyName: String) {
        self.set(integer, forKey: keyName)
    }
    public func set(_ double: Double?, defaultValue: Double, forKey keyName: String) {
        self.set(double, forKey: keyName)
    }
    public func set(_ url: URL?, defaultValue: URL, forKey keyName: String) {
        self.set(url ?? defaultValue, forKey: keyName)
    }
    public func set(_ float: Float?, defaultValue: Float, forKey keyName: String) {
        self.set(float ?? defaultValue, forKey: keyName)
    }
    public func set(_ array: Array<Any>?, defaultValue: Array<Any>, forKey keyName: String) {
        self.set(array ?? defaultValue, forKey: keyName)
    }
    public func set(_ object: Any?, defaultValue: Any, forKey keyName: String) {
        self.set(object ?? defaultValue, forKey: keyName)
    }
    //Set Default Value nullable Support
    public func set(_ string: String?, defaultValue: String?, forKey keyName: String) {
        super.set(string ?? defaultValue, forKey: keyName)
        super.synchronize()
    }
    public func set(_ bool: Bool?, defaultValue: Bool?, forKey keyName: String) {
        super.set(bool ?? defaultValue, forKey: keyName)
        super.synchronize()
    }
    public func set(_ integer: Int?, defaultValue: Int?, forKey keyName: String) {
        super.set(integer, forKey: keyName)
        super.synchronize()
    }
    public func set(_ double: Double?, defaultValue: Double?, forKey keyName: String) {
        super.set(double, forKey: keyName)
        super.synchronize()
    }
    public func set(_ url: URL?, defaultValue: URL?, forKey keyName: String) {
        super.set(url ?? defaultValue, forKey: keyName)
        super.synchronize()
    }
    public func set(_ float: Float?, defaultValue: Float?, forKey keyName: String) {
        super.set(float ?? defaultValue, forKey: keyName)
        super.synchronize()
    }
    public func set(_ array: Array<Any>?, defaultValue: Array<Any>?, forKey keyName: String) {
        super.set(array ?? defaultValue, forKey: keyName)
        super.synchronize()
    }
    public func set(_ object: Any?, defaultValue: Any?, forKey keyName: String) {
        super.set(object ?? defaultValue, forKey: keyName)
        super.synchronize()
    }
}

