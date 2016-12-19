//
//  MOBReview.swift
//  MOBCore
//
//  Created by Jason Morcos on 11/23/16.
//  Copyright © 2016 CBTech. All rights reserved.
//

import UIKit

#if os(iOS)
    open class MOBReview: NSObject {
        internal static let counterKey = "com.moballo.MOBReview.counter"
        internal static let buildVersKey = "com.moballo.MOBReview.lastVers"
        internal static let reviewedCurrentVersKey = "com.moballo.MOBReview.reviewedThisVers"
        internal static let neverReviewKey = "com.moballo.MOBReview.neverReview"
        
        @discardableResult
        public static func incrementOpen() -> Int {
            let countOpenTimes: Int = timesOpened() + 1
            let appBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
            UserDefaults.standard.set(countOpenTimes, forKey: counterKey)
            UserDefaults.standard.set(appBuild, forKey: buildVersKey)
            UserDefaults.standard.synchronize()
            
            return countOpenTimes
        }
        public static func timesOpened() -> Int {
            var timesOpened: Int = 0
            let appBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
            if let stored = UserDefaults.standard.integer(forKey: counterKey) as Int? {
                if let lastVers = UserDefaults.standard.string(forKey: buildVersKey) as String? {
                    if lastVers != appBuild {
                        timesOpened = stored
                        UserDefaults.standard.set(false, forKey: reviewedCurrentVersKey)
                        UserDefaults.standard.synchronize()
                    }
                }
            }
            return timesOpened
        }
        open static func shouldAsk(cutoff: Int = 10) ->  Bool {
            if (UserDefaults.standard.integer(forKey: counterKey) >= cutoff) && (UserDefaults.standard.bool(forKey: reviewedCurrentVersKey) != true) && (UserDefaults.standard.bool(forKey: neverReviewKey) != true)
            {
                return true
            }
            return false
        }
        open static func reviewPopup(appID: String, appName: String, closure: (() -> Swift.Void)?) -> UIAlertController {
            let alertController = UIAlertController(title: "Rate \(appName)", message:
                "If you like using \(appName), could you take a moment to rate it? Positive reviews help promote development. It only takes a minute!\nThanks for your support!", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                UIAlertAction in
                //NSLog("OK Pressed")
                UserDefaults.standard.set(true, forKey: reviewedCurrentVersKey)
                UserDefaults.standard.synchronize()
                
                let address = "itms-apps://itunes.apple.com/app/id\(appID)"
                let url = URL(string: address)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else if #available(iOS 8.0, *) {
                    UIApplication.shared.openURL(url!)
                }
                if let toEx = closure {
                    DispatchQueue.main.sync(execute: toEx)
                }
            }
            let cancelAction = UIAlertAction(title: "Remind Me Later", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
                //NSLog("Cancel Pressed")
                UserDefaults.standard.set(0, forKey: counterKey)
                UserDefaults.standard.synchronize()
                if let toEx = closure {
                    DispatchQueue.main.sync(execute: toEx)
                }
            }
            let neverAction = UIAlertAction(title: "Don't Ask Me Again", style: UIAlertActionStyle.destructive) {
                UIAlertAction in
                //NSLog("Never Pressed")
                UserDefaults.standard.set(true, forKey: neverReviewKey)
                UserDefaults.standard.synchronize()
                if let toEx = closure {
                    DispatchQueue.main.sync(execute: toEx)
                }
            }
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(neverAction)
            alertController.addAction(cancelAction)
            return alertController
        }
    }
#endif
