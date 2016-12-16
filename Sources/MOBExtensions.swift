//
//  AdBannerController.swift
//  MOBAdvertising
//
//  Created by Jason Morcos on 11/23/16.
//  Copyright © 2016 CBTech. All rights reserved.
//

import UIKit

public class MOBExtensions: NSObject {
    
}
extension Sequence {
    
    func toArray() -> [Iterator.Element] {
        
        return Array(self)
    }
}
extension Date {
    func shortString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self) as String
    }
    ///converts to a "10 seconds ago" / "1 day ago" syntax
    func agoString() -> String {
        let deltaTime = -self.timeIntervalSinceNow
        
        //in the past
        if deltaTime > 0 {
            if deltaTime < 60 {
                return "just now"
            }
            if deltaTime < 3600 { //less than an hour
                let amount = Int(deltaTime/60.0)
                let plural = amount == 1 ? "" : "s"
                return "\(amount) Minute\(plural) Ago"
            }
            else if deltaTime < 86400 { //less than a day
                let amount = Int(deltaTime/3600.0)
                let plural = amount == 1 ? "" : "s"
                return "\(amount) Hour\(plural) Ago"
            }
            else if deltaTime < 432000 { //less than five days
                let amount = Int(deltaTime/86400.0)
                let plural = amount == 1 ? "" : "s"
                if amount == 1 {
                    return "Yesterday"
                }
                return "\(amount) Day\(plural) Ago"
            }
        }
        
        //in the future
        if deltaTime < 0 {
            if deltaTime > -60 {
                return "Just Now"
            }
            if deltaTime > -3600 { //in less than an hour
                let amount = -Int(deltaTime/60.0)
                let plural = amount == 1 ? "" : "s"
                return "In \(amount) Minute\(plural)"
            }
            else if deltaTime > -86400 { //in less than a day
                let amount = -Int(deltaTime/3600.0)
                let plural = amount == 1 ? "" : "s"
                return "In \(amount) Hour\(plural)"
            }
            else if deltaTime > -432000 { //in less than five days
                let amount = -Int(deltaTime/86400.0)
                let plural = amount == 1 ? "" : "s"
                if amount == 1 {
                    return "Tomorrow"
                }
                return "In \(amount) Day\(plural)"
            }
        }
        
        let dateString = DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .none)
        return "\(dateString)"
        
    }
}

extension Array {
    ///Returns a copy of the array in random order
    func shuffled() -> [Element] {
        var list = self
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
}

extension Int {
    ///Converts an integer to a standardized three-character string. 1 -> 001. 99 -> 099. 123 -> 123.
    func threeCharacterString() -> String {
        let start = "\(self)"
        let length = start.characters.count
        if length == 1 { return "00\(start)" }
        else if length == 2 { return "0\(start)" }
        else { return start }
    }
}

extension NSObject {
    ///Short-hand function to register a notification observer
    func observeNotification(_ name: String, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }
}

extension UIView {
    
    static func animateWithDuration(_ duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping damping: CGFloat, animations: @escaping () -> ()) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: 0.0, options: [], animations: animations, completion: nil)
    }
    
}

extension String {
    
    var length: Int {
        return (self as NSString).length
    }
    
    func asDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func percentStringAsDouble() -> Double? {
        if let displayedNumber = (self as NSString).substring(to: self.length - 1).asDouble() {
            return displayedNumber / 100.0
        }
        return nil
    }
    
    func isWhitespace() -> Bool {
        return self == " " || self == "\n" || self == "\r" || self == "\r\n" || self == "\t"
            || self == "\u{A0}" || self == "\u{2007}" || self == "\u{202F}" || self == "\u{2060}" || self == "\u{FEFF}"
        //there are lots of whitespace characters apparently
        //http://www.fileformat.info/info/unicode/char/00a0/index.htm
    }
    
    func dateWithTSquareFormat() -> Date? {
        //convert date string to NSDate
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        //correct formatting to match required style
        //(Aug 27, 2015 11:27 am) -> (Aug 27, 2015, 11:27 AM)
        var dateString = self.replacingOccurrences(of: "pm", with: "PM")
        dateString = dateString.replacingOccurrences(of: "am", with: "AM")
        
        for year in 1990...2040 { //add comma after years
            dateString = dateString.replacingOccurrences(of: "\(year) ", with: "\(year), ")
        }
        return formatter.date(from: dateString)
    }
    
}

extension NSString {
    
    func stringAtIndex(_ index: Int) -> String {
        let char = self.character(at: index)
        return "\(Character(UnicodeScalar(char)!))"
    }
    
    func countOccurancesOfString(_ string: String) -> Int {
        let strCount = self.length - self.replacingOccurrences(of: string, with: "").length
        return strCount / string.length
    }
    
}

extension Bundle {
    
    static var applicationVersionNumber: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Version Number Not Available"
    }
    
    static var applicationBuildNumber: String {
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        return "Build Number Not Available"
    }
    
}
extension String {
    func truncate(length: Int, trailing: String? = "") -> String {
        if self.characters.count > length {
            return self.substring(to: self.index(self.startIndex, offsetBy: length)) + (trailing ?? "")
        } else {
            return self
        }
    }
    func cleansed() -> String {
        var text = self as NSString
        //cleanse text of weird formatting
        //tabs and newlines
        text = (text as NSString).replacingOccurrences(of: "\n", with: "") as NSString
        text = (text as NSString).replacingOccurrences(of: "\t", with: "") as NSString
        text = (text as NSString).replacingOccurrences(of: "\r", with: "") as NSString
        text = (text as NSString).replacingOccurrences(of: "<o:p>", with: "") as NSString
        text = (text as NSString).replacingOccurrences(of: "</o:p>", with: "") as NSString
        
        return (text as String).withNoTrailingWhitespace()
    }
    func withNoTrailingWhitespace() -> String {
        var text = self as NSString
        //leading spaces
        while text.length > 1 && text.stringAtIndex(0).isWhitespace() {
            text = text.substring(from: 1) as NSString
        }
        
        //trailing spaces
        while text.length > 1 && text.stringAtIndex(text.length - 1).isWhitespace() {
            text = text.substring(to: text.length - 1) as NSString
        }
        
        return text as String
    }
    
}
extension UIApplication {
    
    func getScreenshot() -> UIImage {
        let layer = UIApplication.shared.keyWindow?.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer!.frame.size, false, scale)
        layer?.render(in: UIGraphicsGetCurrentContext()!)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    func getScreenshotImageData() -> Data {
        let image = getScreenshot()
        if let toReturn = UIImagePNGRepresentation(image) {
            return toReturn
        }
        else if let toReturn = UIImageJPEGRepresentation(image, 1.0) {
            return toReturn
        }
        return Data()
    }
}
extension UIView {
    
    func getViewScreenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
