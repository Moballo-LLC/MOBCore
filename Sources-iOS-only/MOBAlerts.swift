//
//  MOBAlerts.swift
//  MOBCore
//
//  Created by Jason Morcos on 12/4/15.
//  Copyright © 2017 Moballo, LLC. All rights reserved.
//

import UIKit
public var MOBAlertQueue = [MOBAlertController]()
public var MOBAlertTimer: Timer?

public class MOBAlertHandler: NSObject {
    @objc var internalApplication: UIApplication
    @objc public func MOBAlertTimerCall() {
        self.presentAlertController()
    }
    @objc public init(_ application: UIApplication) {
        internalApplication = application
        super.init()
    }
    @objc public func dismissAlert(completion: (() -> Void)? = nil) {
        if let keyWindow = internalApplication.keyWindow {
            if let rootVC = keyWindow.rootViewController {
                let topVC = getTopmostNavController(relativeTo: rootVC)
                
                if topVC.presentedViewController is MOBAlertController {
                    topVC.dismiss(animated: true, completion: completion)
                    return
                }
            }
        }
        if ((completion) != nil) {
            completion!()
        }
    }
    @objc public func tryQueuedAlerts() {
        self.presentAlertController()
    }
    @objc public func minimizeAllAlerts(completion: (() -> Void)? = nil) {
        if let theTimer = MOBAlertTimer , MOBAlertQueue.count == 0 {
            theTimer.invalidate()
            MOBAlertTimer = nil
        }
        if let keyWindow = internalApplication.keyWindow {
            if let rootVC = keyWindow.rootViewController {
                let topVC = getTopmostNavController(relativeTo: rootVC)
                if let currentAlert = topVC.presentedViewController as? MOBAlertController {
                    MOBAlertQueue.insert(currentAlert, at: 0)
                    DispatchQueue.main.async {
                        topVC.dismiss(animated: true, completion: completion)
                    }
                    return
                }
            }
        }
        if ((completion) != nil) {
            completion!()
        }
        
    }
    
    fileprivate func presentAlertController(_ inputAlert: MOBAlertController? = nil, placeOnTopOfQueue:Bool = false, completion: (() -> Void)? = nil) {
        if let keyWindow = internalApplication.keyWindow {
            if let rootVC = keyWindow.rootViewController {
                let topVC = getTopmostNavController(relativeTo: rootVC)
                
                if let inputAlertItem = inputAlert {
                    if let alertIdentifier = inputAlertItem.alertIdentifier {
                        if let presented = topVC.presentedViewController as? MOBAlertController {
                            if presented.alertIdentifier == alertIdentifier {
                                return
                            }
                        }
                        if MOBAlertQueue.count > 0 {
                            for anAlert in MOBAlertQueue {
                                if anAlert.alertIdentifier == alertIdentifier {
                                    return
                                }
                            }
                        }
                    }
                    if (placeOnTopOfQueue) {
                        MOBAlertQueue.insert(inputAlertItem, at: 0)
                    } else {
                        MOBAlertQueue.append(inputAlertItem)
                    }
                }
                if MOBAlertTimer == nil {
                    MOBAlertTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.MOBAlertTimerCall), userInfo: nil, repeats: true)
                }
                
                if let _ = topVC.presentedViewController as? UIAlertController {
                    return
                }
                if MOBAlertQueue.count > 0 && topVC.isViewLoaded {
                    if let toPresent = MOBAlertQueue.first {
                        toPresent.alertHandler = self
                        topVC.present(toPresent, animated: true, completion: {
                            if ((completion) != nil) {
                                completion!()
                            }
                            if let textFields = toPresent.textFields , (keyWindow.bounds.height < 667.0 && keyWindow.bounds.width < 667.0) {
                                self.mobAlertDelay(0.1) {
                                    toPresent.resignFirstResponder()
                                    for aField in textFields {
                                        aField.resignFirstResponder()
                                    }
                                    toPresent.resignFirstResponder()
                                }
                            }
                            if MOBAlertQueue.count > 0 {
                                MOBAlertQueue.removeFirst()
                            }
                            if let theTimer = MOBAlertTimer , MOBAlertQueue.count == 0 {
                                theTimer.invalidate()
                                MOBAlertTimer = nil
                            }
                        })
                    }
                }
            }
        }
        
        if let theTimer = MOBAlertTimer , MOBAlertQueue.count == 0 {
            theTimer.invalidate()
            MOBAlertTimer = nil
        }
    }
    private func getTopmostNavController(relativeTo inputView: UIViewController) -> UIViewController {
        if let presented = inputView.presentedViewController as? UINavigationController {
            return getTopmostNavController(relativeTo: presented)
        }
        return inputView
    }
    private func mobAlertDelay(_ delay: Double, closure: @escaping ()->()) {
        let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: closure)
    }
    @objc public static func resetQueue() {
        if let theTimer = MOBAlertTimer {
            theTimer.invalidate()
        }
        MOBAlertQueue = [MOBAlertController]()
    }
}
public class MOBAlertController: UIAlertController {
    //used to make duplicate alerts not a thing
    @objc public var alertIdentifier: String?
    @objc var alertHandler: MOBAlertHandler?
    
    @objc public static func alertControllerWithTitle(title:String?,message:String?,actions:[UIAlertAction],dismissingActionTitle:String? = "Dismiss", dismissBlock:(() -> ())?) -> MOBAlertController {
        let alertController = MOBAlertController(title: title, message: message, preferredStyle: .alert)
        if dismissingActionTitle != nil {
            let okAction = UIAlertAction(title: dismissingActionTitle, style: .default) { (action) -> Void in
                if dismissBlock != nil {
                    dismissBlock?()
                }
            }
            alertController.addAction(okAction)
        }
        for action in actions {
            alertController.addAction(action)
        }
        return alertController
    }
    deinit {
        if let handler = alertHandler {
            handler.tryQueuedAlerts()
        }
    }
    @objc public func show(_ application: UIApplication) {
        let handler = MOBAlertHandler(application)
        handler.presentAlertController(self)
    }
    @objc public func showNow(_ application: UIApplication, completion: (() -> Void)? = nil) {
        let handler = MOBAlertHandler(application)
        handler.minimizeAllAlerts()
        handler.presentAlertController(self, placeOnTopOfQueue: true, completion: completion)
    }
    @objc public func showNext(_ application: UIApplication) {
        let handler = MOBAlertHandler(application)
        handler.presentAlertController(self, placeOnTopOfQueue: true)
    }
}
