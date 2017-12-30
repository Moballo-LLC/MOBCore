//
//  MOBExtensions.swift
//  MOBCore
//
//  Created by Jason Morcos on 12/4/15.
//  Copyright © 2017 Moballo, LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
    import CoreLocation
    import MapKit
    //SET MOBALLO VARIABLES HERE
    public class MOBInternalConstants : NSObject {
        static public let copyrightEntity = "Moballo, LLC"
        static public let supportWebsite = "http://moballo.com"
        static public let supportEmail = "support@moballo.com"
    }
    //EXTENSIONS BEGIN HERE
    extension Sequence {
        public func toArray() -> [Iterator.Element] {
            return Array(self)
        }
        /// Returns an array with the contents of this sequence, shuffled.
        public func shuffled() -> [Element] {
            var result = Array(self)
            result.shuffle()
            return result
        }
    }
    extension UITableView {
        @objc public func deselectAllCells() {
            if self.indexPathsForSelectedRows != nil {
                if self.indexPathsForSelectedRows! != [] {
                    for cell in self.indexPathsForSelectedRows! {
                        self.deselectRow(at: cell, animated: false)
                    }
                }
            }
        }
    }
    extension UISearchBar {
        public var isEmpty: Bool {
            // Returns true if the text is empty or nil
            return self.text?.isEmpty ?? true
        }
        @objc public func setColorscheme(barBackgroundColor: UIColor, barTintColor: UIColor, tintColor: UIColor, textboxBackgroundColor: UIColor, textColor: UIColor, cursorColor: UIColor, translucent: Bool, opaque: Bool) {
            if #available(iOS 11.0, *) {
                self.backgroundColor = barBackgroundColor
                self.isOpaque = opaque
                self.isTranslucent = translucent
                self.tintColor = tintColor
                self.barTintColor = barTintColor
                
                if self.subviews.count > 0 {
                    let view: UIView = self.subviews[0] as UIView
                    let subViewsArray = view.subviews
                    for subView: UIView in subViewsArray {
                        if subView.isKind(of: UITextField.self){
                            subView.tintColor = cursorColor
                            if let texted = subView as? UITextField {
                                texted.textColor = textColor
                                texted.font = UIFont.systemFont(ofSize: 16.0)
                            }
                            if let backgroundview = subView.subviews.first {
                                backgroundview.backgroundColor = textboxBackgroundColor
                                
                                // Rounded corner
                                backgroundview.layer.cornerRadius = 10;
                                backgroundview.clipsToBounds = true;
                            }
                        }
                    }
                }
            } else {
                self.barTintColor = barTintColor
                self.backgroundColor = barBackgroundColor
                self.isTranslucent = translucent
                self.isOpaque = opaque
                self.tintColor = tintColor
                if self.subviews.count > 0 {
                    let view: UIView = self.subviews[0] as UIView
                    let subViewsArray = view.subviews
                    
                    for subView: UIView in subViewsArray {
                        if subView.isKind(of: UITextField.self){
                            subView.tintColor = cursorColor
                            //subView.tintColor = goldColor
                            if let texted = subView as? UITextField {
                                texted.textColor = textColor
                                texted.font = UIFont.systemFont(ofSize: 16.0)
                            }
                            if let backgroundview = subView.subviews.first {
                                backgroundview.backgroundColor = textboxBackgroundColor
                                
                                // Rounded corner
                                backgroundview.layer.cornerRadius = 10;
                                backgroundview.clipsToBounds = true;
                            }
                        }
                    }
                }
            }
        }
    }
    extension Date {
        public func formattedFromCompenents(styleAttitude: DateFormatter.Style, year: Bool = false, month: Bool = false, day: Bool = false, hour: Bool = false, minute: Bool = false, second: Bool = false, locale: Locale = Locale.current) -> String {
            let long = styleAttitude == .long || styleAttitude == .full
            let short = styleAttitude == .short
            var comps = ""
            
            if year { comps += long ? "yyyy" : "yy" }
            if month { comps += long ? "MMMM" : (short ? "MM" : "MMM") }
            if day { comps += long ? "dd" : "d" }
            
            if hour { comps += long ? "HH" : "H" }
            if minute { comps += long ? "mm" : "m" }
            if second { comps += long ? "ss" : "s" }
            let format = DateFormatter.dateFormat(fromTemplate: comps, options: 00, locale: locale)
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.string(from: self)
        }
        public func shortString() -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: self) as String
        }
        public func shortDateString() -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter.string(from: self) as String
        }
        public func mediumDateString() -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: self) as String
        }
        public func shortTimeString() -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            return formatter.string(from: self) as String
        }
        public func mediumTimeString() -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .medium
            return formatter.string(from: self) as String
        }
        public func shortDateNoYearString() -> String {
            return self.formattedFromCompenents(styleAttitude: .short, year: false, month: true, day: true)
        }
        public func mediumDateNoYearString() -> String {
            return self.formattedFromCompenents(styleAttitude: .medium, year: false, month: true, day: true)
        }
        public func longDateNoYearString() -> String {
            return self.formattedFromCompenents(styleAttitude: .long, year: false, month: true, day: true)
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
        public var isToday: Bool {
            return Calendar.current.isDateInToday(self)
        }
        public var isYesterday: Bool {
            return Calendar.current.isDateInYesterday(self)
        }
        public var isTomorrow: Bool {
            return Calendar.current.isDateInTomorrow(self)
        }
        public func withoutTime() -> Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.date(from: dateFormatter.string(from: self))
        }
        public func withoutTimeAndYear() -> Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd"
            return dateFormatter.date(from: dateFormatter.string(from: self))
        }
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
            let difference = calendar.dateComponents([.day], from: self, to: otherDate)
            return difference.day!
        }
        public func isSameDay(as otherDate: Date) -> Bool {
            let order = Calendar.current.compare(self, to: otherDate, toGranularity: .day)
            switch order {
            case .orderedSame:
                return true
            default:
                return false
            }
        }
    }
    
    extension Array {
        ///Shuffles the contents of this collection
        mutating func shuffle() {
            let c = count
            guard c > 1 else { return }
            
            for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
                let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
                let i = index(firstUnshuffled, offsetBy: d)
                swapAt(firstUnshuffled, i)
            }
        }
    }
    
    extension Int {
        ///Converts an integer to a standardized three-character string. 1 -> 001. 99 -> 099. 123 -> 123.
        public func threeCharacterString() -> String {
            let start = "\(self)"
            let length = start.length
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
    extension NSString {
        @objc public func stringAtIndex(_ index: Int) -> String {
            let char = self.character(at: index)
            return "\(Character(UnicodeScalar(char)!))"
        }
    }
    public extension NSNumber {
        @objc public func degreesToCardinalDirection()->String {
            let headingDeg:Double = Double((self.doubleValue + 720.0)).truncatingRemainder(dividingBy: 360)
            if(headingDeg > 348.15) {
                return "N"
            } else if (headingDeg > 326.25) {
                return "NNW"
            } else if (headingDeg > 303.75) {
                return "NW"
            } else if (headingDeg > 281.25) {
                return "WNW"
            } else if (headingDeg > 258.75) {
                return "W"
            } else if (headingDeg > 236.25) {
                return "WSW"
            } else if (headingDeg > 213.75) {
                return "SW"
            } else if (headingDeg > 191.25) {
                return "SSW"
            } else if (headingDeg > 168.75) {
                return "S"
            } else if (headingDeg > 146.25) {
                return "SSE"
            } else if (headingDeg > 123.75) {
                return "SE"
            } else if (headingDeg > 101.25) {
                return "ESE"
            } else if (headingDeg > 78.75) {
                return "E"
            } else if (headingDeg > 56.25) {
                return "ENE"
            } else if (headingDeg > 33.75) {
                return "NE"
            } else if (headingDeg > 11.25) {
                return "NNE"
            }
            return "N"
        }
    }
    extension UIApplication {
        @objc public func getScreenshot() -> UIImage {
            let layer = self.keyWindow?.layer
            let scale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(layer!.frame.size, false, scale)
            layer?.render(in: UIGraphicsGetCurrentContext()!)
            return UIGraphicsGetImageFromCurrentImageContext()!
        }
        @objc public func getScreenshotImageData() -> Data {
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
            let year = Calendar.current.component(.year, from: Date())
            return "© "+String(year)+" "+copyrightEntity
            
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
        public static var isExtension: Bool {
            get {
                return Bundle.main.bundlePath.hasSuffix(".appex")
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
        @objc public func getViewScreenshot() -> UIImage {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
            
            drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
        }
        public static func animateWithDuration(_ duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping damping: CGFloat, animations: @escaping () -> ()) {
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: 0.0, options: [], animations: animations, completion: nil)
        }
    }
    
    extension UIImage {
        public static func solidColor(_ color: UIColor, size: CGSize) -> UIImage {
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            color.setFill()
            UIRectFill(rect)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        }
        @objc public func colorize(_ tintColor: UIColor) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
            
            let context = UIGraphicsGetCurrentContext()// as CGContextRef
            context?.translateBy(x: 0, y: self.size.height)
            context?.scaleBy(x: 1.0, y: -1.0);
            context?.setBlendMode(CGBlendMode.normal)
            
            let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
            context?.clip(to: rect, mask: self.cgImage!)
            tintColor.setFill()
            context?.fill(rect)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
            UIGraphicsEndImageContext()
            
            return newImage
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
        @objc public func chooseMapType(mapKey: String, popupOrigin: Any, presenter: UIViewController) {
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
        @objc public func chooseMapTypeDialog(mapKey: String) -> UIAlertController {
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
        @objc public func setMapType(mapKey: String) {
            if let storedType = UserDefaults.standard.object(forKey: self.mapTypeKey(mapKey: mapKey)) as! UInt? {
                if let mapTypeInstance = MKMapType(rawValue: storedType) {
                    self.mapType = mapTypeInstance
                    return
                }
            }
            self.mapType = .standard
        }
    }
    extension String {
        public func minHeight(width: CGFloat, font: UIFont, numberOfLines: Int = 0, lineBreakMode: NSLineBreakMode = NSLineBreakMode.byWordWrapping) -> CGFloat {
            let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = numberOfLines
            label.lineBreakMode = lineBreakMode
            label.font = font
            label.text = self
            
            label.sizeToFit()
            return label.frame.height
        }
    }
    extension UILabel {
        @objc public func minHeight() -> CGFloat {
            guard let text = self.text else { return 0 }
            return text.minHeight(width: self.frame.width, font: self.font, numberOfLines: self.numberOfLines, lineBreakMode: self.lineBreakMode)
        }
        @objc public func minHeight(forText text: String) -> CGFloat {
            return text.minHeight(width: self.frame.width, font: self.font, numberOfLines: self.numberOfLines, lineBreakMode: self.lineBreakMode)
        }
    }
    extension UIDevice {
        public static var isIpad: Bool {
            get {
                if #available(iOS 9.0, *) {
                    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
                } else {
                    return false
                }
            }
        }
        public static var isIphone: Bool {
            get {
                if #available(iOS 9.0, *) {
                    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
                } else {
                    return false
                }
            }
        }
        public static var isCarplay: Bool {
            get {
                if #available(iOS 9.0, *) {
                    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.carPlay
                } else {
                    return false
                }
            }
        }
        public static var isTV: Bool {
            get {
                if #available(iOS 9.0, *) {
                    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.tv
                } else {
                    return false
                }
            }
        }
        public static var isSimulator: Bool {
            get {
                return TARGET_OS_SIMULATOR != 0
            }
        }
        public static var modelCode: String {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            return identifier
        }
        
    }
    ///Fuzzy comparison funcs
    public func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
        switch (lhs, rhs) {
        case let (l?, r?):
            return l < r
        case (nil, _?):
            return true
        default:
            return false
        }
    }
    
    public func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
        switch (lhs, rhs) {
        case let (l?, r?):
            return l > r
        default:
            return rhs < lhs
        }
    }
    
    public func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
        switch (lhs, rhs) {
        case let (l?, r?):
            return l <= r
        default:
            return !(rhs < lhs)
        }
    }
#elseif os(watchOS)
    import UIKit
#endif


//Shared Extensions
extension String {
    public func countOccurances(ofSubstring string: String) -> Int {
        let strCount = self.length - self.replacingOccurrences(of: string, with: "").length
        return strCount / string.length
    }
    
    public func onlyAlphanumerics(keepSpaces: Bool = false)->String {
        var filteringSet = CharacterSet.alphanumerics.inverted
        if keepSpaces {
            filteringSet.remove(" ")
        }
        return self.removingCharacters(in: filteringSet)
    }
    
    public func substring(from index1: String.Index, to index2: String.Index) -> String {
        return String(self[index1..<index2])
    }
    
    public func substring(to index: String.Index) -> String {
        return String(self[..<index])
    }
    
    public func substring(from index: String.Index) -> String {
        return String(self[index...])
    }
    
    public func asDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
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
    
    public func percentStringAsDouble() -> Double? {
        if self.length > 0 {
            if let displayedNumber = self.substring(to: self.index(self.endIndex, offsetBy: -1)).asDouble() {
                return displayedNumber / 100.0
            }
        }
        return nil
    }
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    public func removingCharacters(in characterSet: CharacterSet) -> String {
        return self.components(separatedBy: characterSet).joined()
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return String(self[Range(start ..< end)])
    }
    public func strippedWebsiteForURL() -> String {
        ///converts "http://www.google.com/search/page/saiojdfghadlsifuhlaisdf" to "google.com"
        var stripped = self.replacingOccurrences(of: "http://", with: "")
        stripped = stripped.replacingOccurrences(of: "https://", with: "")
        stripped = stripped.replacingOccurrences(of: "www.", with: "")
        return stripped.components(separatedBy: "/")[0]
    }
    public func truncate(length: Int, trailing: String? = "") -> String {
        if self.length > length {
            return self.substring(to: self.index(self.startIndex, offsetBy: length)) + (trailing ?? "")
        } else {
            return self
        }
    }
    public func cleansed() -> String {
        return self.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "<o:p>", with: "").replacingOccurrences(of: "</o:p>", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    public func trimWhitespace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    public func withNoTrailingWhitespace() -> String {
        if let trailingWs = self.range(of: "\\s+$", options: .regularExpression) {
            return self.replacingCharacters(in: trailingWs, with: "")
        } else {
            return self
        }
    }
    public func withNoLeadingWhitespace() -> String {
        if let leadingWs = self.range(of: "$+\\s", options: .regularExpression) {
            return self.replacingCharacters(in: leadingWs, with: "")
        } else {
            return self
        }
    }
    public var length: Int {
        return self.count
    }
    
    public var hasWhitespace: Bool {
        if self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil {
            return true
        }
        return false
    }
    
    public func formattedAsPhone() -> String {
        if self.length == 10 {
            let s = self
            let s2 = String(format: "(%@) %@-%@",
                            s.substring(to: s.index(s.startIndex, offsetBy: 3)),
                            s.substring(from: s.index(s.startIndex, offsetBy: 3), to: s.index(s.startIndex, offsetBy: 6)),
                            s.substring(from: s.index(s.startIndex, offsetBy: 6))
            )
            return s2
        } else if self.length == 11 {
            let s = self
            let s2 = String(format: "+%@ (%@) %@-%@",
                            s.substring(to: s.index(s.startIndex, offsetBy: 1)),
                            s.substring(from: s.index(s.startIndex, offsetBy: 1), to: s.index(s.startIndex, offsetBy: 4)),
                            s.substring(from: s.index(s.startIndex, offsetBy: 4), to: s.index(s.startIndex, offsetBy: 7)),
                            s.substring(from: s.index(s.startIndex, offsetBy: 7))
                
            )
            return s2
        } else if self.length == 7 {
            let s = self
            let s2 = String(format: "%@-%@",
                            s.substring(to: s.index(s.startIndex, offsetBy: 3)),
                            s.substring(from: s.index(s.startIndex, offsetBy: 3))
            )
            return s2
        }
        return self
    }
    
    public func contains(all array: [String]) -> Bool {
        for aString in array {
            if !self.contains(aString) {
                return false
            }
        }
        return true
    }
    
    public func contains(any array: [String]) -> Bool {
        for aString in array {
            if self.contains(aString) {
                return true
            }
        }
        return false
    }
}
