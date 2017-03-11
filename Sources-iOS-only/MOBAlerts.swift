//
//  MOBAlerts.swift
//  Pods
//
//  Created by Jason Morcos on 3/11/17.
//
//

import UIKit
public var MOBAlertQueue = [MOBAlertController]()
public var MOBAlertTimer: Timer?

public class MOBAlertHandler: NSObject {
    var internalApplication: UIApplication
    public func MOBAlertTimerCall() {
        self.presentAlertController()
    }
    public init(_ application: UIApplication) {
        internalApplication = application
        super.init()
    }
    public func tryQueuedAlerts() {
        self.presentAlertController()
    }
    
    fileprivate func presentAlertController(_ newController: MOBAlertController? = nil) {
        if let keyWindow = internalApplication.keyWindow {
            if let rootVC = keyWindow.rootViewController {
                let topVC = getTopmostNavController(relativeTo: rootVC)
                
                if let toPresent = newController {
                    if let alertIdentifier = toPresent.alertIdentifier {
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
                    MOBAlertQueue.append(newController!)
                }
                if MOBAlertTimer == nil {
                    MOBAlertTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.MOBAlertTimerCall), userInfo: nil, repeats: true)
                }
        
                if let _ = topVC.presentedViewController as? UIAlertController {
                    return
                }
                if MOBAlertQueue.count > 0 && topVC.isViewLoaded {
                    if let toPresent = MOBAlertQueue.first {
                        toPresent.alertHandler = self
                        topVC.present(toPresent, animated: true, completion: {
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
    public static func resetQueue() {
        if let theTimer = MOBAlertTimer {
            theTimer.invalidate()
        }
        MOBAlertQueue = [MOBAlertController]()
    }
}
public class MOBAlertController: UIAlertController {
    //used to make duplicate alerts not a thing
    public var alertIdentifier: String?
    var alertHandler: MOBAlertHandler?
    
    public static func alertControllerWithTitle(title:String?,message:String?,actions:[UIAlertAction],dismissingActionTitle:String? = "Dismiss", dismissBlock:(() -> ())?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if dismissingActionTitle != nil {
            let okAction = UIAlertAction(title: dismissingActionTitle, style: .default) { (action) -> Void in
                dismissBlock?()
                alertController.dismiss(animated: true, completion:nil)
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
            handler.presentAlertController()
        }
    }
    public func show(_ application: UIApplication) {
        let handler = MOBAlertHandler(application)
        handler.presentAlertController(self)
    }
}