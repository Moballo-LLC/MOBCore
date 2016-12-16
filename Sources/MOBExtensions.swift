//
//  MOBExtensions.swift
//  MOBAdvertising
//
//  Created by Jason Morcos on 11/23/16.
//  Copyright © 2016 CBTech. All rights reserved.
//
#if os(iOS)
    import UIKit
    
    extension Sequence {
        
        public func toArray() -> [Iterator.Element] {
            
            return Array(self)
        }
    }
    extension Date {
        public func shortString() -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: self) as String
        }
        ///converts to a "10 seconds ago" / "1 day ago" syntax
        public func agoString() -> String {
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
        public func shuffled() -> [Element] {
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
        public func threeCharacterString() -> String {
            let start = "\(self)"
            let length = start.characters.count
            if length == 1 { return "00\(start)" }
            else if length == 2 { return "0\(start)" }
            else { return start }
        }
    }
    
    extension NSObject {
        ///Short-hand function to register a notification observer
        public func observeNotification(_ name: String, selector: Selector) {
            NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
        }
    }
    
    extension UIView {
        
        public static func animateWithDuration(_ duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping damping: CGFloat, animations: @escaping () -> ()) {
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: 0.0, options: [], animations: animations, completion: nil)
        }
        
    }
    
    extension String {
        
        public var length: Int {
            return (self as NSString).length
        }
        
        public func asDouble() -> Double? {
            return NumberFormatter().number(from: self)?.doubleValue
        }
        
        public func percentStringAsDouble() -> Double? {
            if let displayedNumber = (self as NSString).substring(to: self.length - 1).asDouble() {
                return displayedNumber / 100.0
            }
            return nil
        }
        
        public func isWhitespace() -> Bool {
            return self == " " || self == "\n" || self == "\r" || self == "\r\n" || self == "\t"
                || self == "\u{A0}" || self == "\u{2007}" || self == "\u{202F}" || self == "\u{2060}" || self == "\u{FEFF}"
            //there are lots of whitespace characters apparently
            //http://www.fileformat.info/info/unicode/char/00a0/index.htm
        }
        
        public func dateWithTSquareFormat() -> Date? {
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
        
        public func stringAtIndex(_ index: Int) -> String {
            let char = self.character(at: index)
            return "\(Character(UnicodeScalar(char)!))"
        }
        
        public func countOccurancesOfString(_ string: String) -> Int {
            let strCount = self.length - self.replacingOccurrences(of: string, with: "").length
            return strCount / string.length
        }
        
    }
    
    extension Bundle {
        public static var applicationVersionNumber: String {
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                return version
            }
            return "Version Number Not Available"
        }
        
        public static var applicationBuildNumber: String {
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                return build
            }
            return "Build Number Not Available"
        }
        
    }
    extension String {
        public func truncate(length: Int, trailing: String? = "") -> String {
            if self.characters.count > length {
                return self.substring(to: self.index(self.startIndex, offsetBy: length)) + (trailing ?? "")
            } else {
                return self
            }
        }
        public func cleansed() -> String {
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
        public func withNoTrailingWhitespace() -> String {
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
        public func getScreenshot() -> UIImage {
            let layer = self.keyWindow?.layer
            let scale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(layer!.frame.size, false, scale)
            layer?.render(in: UIGraphicsGetCurrentContext()!)
            return UIGraphicsGetImageFromCurrentImageContext()!
        }
        public func getScreenshotImageData() -> Data {
            let image = getScreenshot()
            if let toReturn = UIImagePNGRepresentation(image) {
                return toReturn
            }
            else if let toReturn = UIImageJPEGRepresentation(image, 1.0) {
                return toReturn
            }
            return Data()
        }
        public static func appInfo() -> String {
            let date = Date()
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
            let year =  components.year
            let actualAppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
            let actualAppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
            let infoText = "Version: \(actualAppVersion)\nBuild: \(actualAppBuild)\n \nContact Us: support@moballo.com\nWebsite: http://moballo.com\n\n© \(year! as Int) Moballo, LLC"
            return infoText
        }
        public static var isRunningSimulator: Bool {
            get {
                return TARGET_OS_SIMULATOR != 0
            }
        }
        public static var isTestFlight: Bool {
            get {
                if let url = Bundle.main.appStoreReceiptURL {
                    return (url.lastPathComponent == "sandboxReceipt")
                }
                return false
            }
        }
    }
    extension UIView {
        
        public func getViewScreenshot() -> UIImage {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
            
            drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
        }
    }
    
    extension UIImage {
        public static func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            color.setFill()
            UIRectFill(rect)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        }
    }
    extension CLLocationCoordinate2D {
        func isInRegion(region: MKCoordinateRegion) -> Bool {
            let center   = region.center
            var northWestCorner = center
            var southEastCorner = center
            
            northWestCorner.latitude  = center.latitude  - (region.span.latitudeDelta  / 2.0);
            northWestCorner.longitude = center.longitude - (region.span.longitudeDelta / 2.0);
            southEastCorner.latitude  = center.latitude  + (region.span.latitudeDelta  / 2.0);
            southEastCorner.longitude = center.longitude + (region.span.longitudeDelta / 2.0);
            
            if (
                self.latitude  >= northWestCorner.latitude &&
                    self.latitude  <= southEastCorner.latitude &&
                    
                    self.longitude >= northWestCorner.longitude &&
                    self.longitude <= southEastCorner.longitude
                )
            {
                return true
            }
            return false
        }
        
    }
    extension CLLocationCoordinate2D {
        func containsCoordinate(coordinate: CLLocationCoordinate2D) -> Bool {
            return coordinate.isInRegion(region: self);
        }
        
    }
    extension UIViewController {
        public var isModal: Bool {
            return self.presentingViewController?.presentedViewController == self
                || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController)
                || self.tabBarController?.presentingViewController is UITabBarController
        }
    }
    extension Data {
        public func firstBytes(_ length: Int) -> [UInt8] {
            var bytes: [UInt8] = [UInt8](repeating: 0, count: length)
            (self as NSData).getBytes(&bytes, length: length)
            return bytes
        }
        public var isIcs: Bool {
            let signature:[UInt8] = [66, 69, 71, 73]
            return firstBytes(4) == signature
        }
    }
    extension Date {
        public func stringLiteralOfDate() -> String {
            let dateFormatter = DateFormatter()
            let theDateFormat = DateFormatter.Style.short
            let theTimeFormat = DateFormatter.Style.long
            
            dateFormatter.dateStyle = theDateFormat
            dateFormatter.timeStyle = theTimeFormat
            
            return dateFormatter.string(from: self)
        }
        public func daysUntil(_ otherDate: Date) -> Int
        {
            let calendar = Calendar.current
            
            let components = (calendar as NSCalendar).components([.day], from: self, to: otherDate, options: [])
            
            return components.day!
        }
    }
#endif
