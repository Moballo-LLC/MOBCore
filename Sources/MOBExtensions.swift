//
//  MOBExtensions.swift
//  MOBCore
//
//  Created by Jason Morcos on 11/23/16.
//  Copyright © 2016 CBTech. All rights reserved.
//
#if os(iOS)
    import UIKit
    import CoreLocation
    import MapKit
    //SET MOBALLO VARIABLES HERE
    internal class MOBInternalConstants : NSObject {
        static internal let copyrightEntity = "Moballo, LLC"
        static internal let supportWebsite = "http://moballo.com"
        static internal let supportEmail = "support@moballo.com"
    }
    //EXTENSIONS BEGIN HERE
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
    extension UIDevice {
        public func isIpad() -> Bool {
            return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
        }
        public func isIphone() -> Bool {
            return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
        }
        public func isCarplay() -> Bool {
            if #available(iOS 9.0, *) {
                return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.carPlay
            } else {
                return false
            }
        }
        public func isTV() -> Bool {
            if #available(iOS 9.0, *) {
                return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.tv
            } else {
                return false
            }
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
        public static func appVersion() -> String {
            return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        }
        public static func appBuild() -> String {
            return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        }
        public static func appCopyright(customCopyright: String? = nil) -> String {
            let copyrightEntity: String
            if let overwriteEntityCopyright = customCopyright {
                copyrightEntity = overwriteEntityCopyright
            } else {
                copyrightEntity = MOBInternalConstants.copyrightEntity
            }
            let date = Date()
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
            let year =  components.year
            return "© \(year! as Int) \(copyrightEntity)"
            
        }
        public static func appInfo(customCopyright: String? = nil) -> String {
            let copyright: String
            if let overwriteEntityCopyright = customCopyright {
                copyright = UIApplication.appCopyright(customCopyright: overwriteEntityCopyright)
            } else {
                copyright = UIApplication.appCopyright()
            }
            let infoText = "Version: \(UIApplication.appVersion())\nBuild: \(UIApplication.appBuild())\n \nContact Us: \(MOBInternalConstants.supportEmail)\nWebsite: \(MOBInternalConstants.supportWebsite)\n\n\(copyright)"
            return infoText
        }
        public static func appAboutController(appName: String, customCopyright: String? = nil) ->UIAlertController {
            let infoText:String
            if let overwriteEntityCopyright = customCopyright {
                infoText = UIApplication.appInfo(customCopyright: overwriteEntityCopyright)
            } else {
                infoText = UIApplication.appInfo()
            }
            let alertController = UIAlertController(title: appName, message: infoText, preferredStyle: UIAlertControllerStyle.alert)
            let Dismiss = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
            }
            alertController.addAction(Dismiss)
            return alertController;
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
        public func isIn(region: MKCoordinateRegion) -> Bool {
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
    extension MKCoordinateRegion {
        public func contains(coordinate: CLLocationCoordinate2D) -> Bool {
            return coordinate.isIn(region: self);
        }
        public func with(padding: CLLocationDegrees) -> MKCoordinateRegion {
            var newReg = self
            newReg.span.latitudeDelta = padding*2 + newReg.span.latitudeDelta
            newReg.span.longitudeDelta = padding*2 + newReg.span.longitudeDelta
            return newReg
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
    extension UIAlertController {
        //does not support text fields
        public func duplicate(preferredStyle: UIAlertControllerStyle? = nil) ->UIAlertController {
            let newStyle:UIAlertControllerStyle
            if let overrideStyle = preferredStyle {
                newStyle = overrideStyle
            } else {
                newStyle = self.preferredStyle
            }
            let newActions = self.actions
            let newTitle = self.title
            let newMessage = self.message
            let newController = UIAlertController(title: newTitle, message: newMessage, preferredStyle: newStyle)
            if #available(iOS 9.0, *) {
                newController.preferredAction = self.preferredAction
            }
            for anAction in newActions {
                newController.addAction(anAction)
            }
            return newController
        }
    }
    extension MKMapView {
        internal func mapTypeKey(mapKey: String)-> String {
            return "com.moballo.map."+mapKey+".map-type"
        }
        public func chooseMapType(mapKey: String, popupOrigin: Any, presenter: UIViewController) {
            let alertController = self.chooseMapTypeDialog(mapKey: mapKey)
            if let popoverController = alertController.popoverPresentationController {
                if let popupOriginButton = popupOrigin as? UIBarButtonItem {
                    popoverController.barButtonItem = popupOriginButton
                } else if let popupOriginRect = popupOrigin as? CGRect {
                    popoverController.sourceRect = popupOriginRect
                } else {
                    print("THIS POPUP WOULD CRASH ON IPAD, SO REVERTING TYPE")
                    let alternateController = alertController.duplicate(preferredStyle: .alert)
                    presenter.present(alternateController, animated: true, completion: nil)
                    return
                }
            }
            presenter.present(alertController, animated: true, completion: nil)
        }
        public func chooseMapTypeDialog(mapKey: String) -> UIAlertController {
            let chooseDialog = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let chooseStandardOption = UIAlertAction(title: "Standard", style: .default, handler: { (_) in
                let newMapType = MKMapType.standard
                UserDefaults.standard.set(newMapType.rawValue, forKey: self.mapTypeKey(mapKey: mapKey))
                UserDefaults.standard.synchronize()
                self.mapType = newMapType
            })
            chooseDialog.addAction(chooseStandardOption)
            
            let chooseHybridOption = UIAlertAction(title: "Hybrid", style: .default, handler: { (_) in
                let newMapType = MKMapType.hybrid
                UserDefaults.standard.set(newMapType.rawValue, forKey: self.mapTypeKey(mapKey: mapKey))
                UserDefaults.standard.synchronize()
                self.mapType = newMapType
            })
            chooseDialog.addAction(chooseHybridOption)
            
            let chooseSatelliteOption = UIAlertAction(title: "Satellite", style: .default, handler: { (_) in
                let newMapType = MKMapType.satellite
                UserDefaults.standard.set(newMapType.rawValue, forKey: self.mapTypeKey(mapKey: mapKey))
                UserDefaults.standard.synchronize()
                self.mapType = newMapType
            })
            chooseDialog.addAction(chooseSatelliteOption)
            
            let cancelOption = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                
            })
            chooseDialog.addAction(cancelOption)
            
            return chooseDialog
        }
        public func setMapType(mapKey: String) {
            if let storedType = UserDefaults.standard.object(forKey: self.mapTypeKey(mapKey: mapKey)) as! UInt? {
                if let mapTypeInstance = MKMapType(rawValue: storedType) {
                    self.mapType = mapTypeInstance
                    return
                }
            }
            self.mapType = .standard
        }
    }
#endif
