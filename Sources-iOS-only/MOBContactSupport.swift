//
//  Downloader.swift
//  MOBCore
//
//  Created by Jason Morcos on 12/4/15.
//  Copyright © 2017 Moballo, LLC. All rights reserved.
//

import UIKit
import MessageUI

@objc open class MOBContactSupport: NSObject {
    let mailComposerVC: MFMailComposeViewController
    let parentController: UIViewController
    let parentDelegate: MFMailComposeViewControllerDelegate
    public init(parent parentController: UIViewController, parent parentDelegate: MFMailComposeViewControllerDelegate, subject: String, message: String, appName: String? = nil, toEmails:[String] = [MOBInternalConstants.supportEmail], isHTML:Bool = false) {
        self.parentController = parentController
        self.parentDelegate = parentDelegate
        self.mailComposerVC = MFMailComposeViewController()
        super.init()
        mailComposerVC.mailComposeDelegate = parentDelegate
        mailComposerVC.setSubject(subject)
        mailComposerVC.setToRecipients(toEmails)
        mailComposerVC.setMessageBody("\(message)\(self.messageFooter(appName: appName))", isHTML: isHTML)
    }
    public func present() {
        if MFMailComposeViewController.canSendMail() {
            parentController.present(mailComposerVC, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
            
        }
    }
    public func view() -> UIViewController? {
        if MFMailComposeViewController.canSendMail() {
            return mailComposerVC
        }
        self.showSendMailErrorAlert()
        return nil
    }
    open func messageFooter(appName: String? = nil) -> String {
        let actualAppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let actualAppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        let actualDeviceName = UIDevice.current.name as String
        let actualOperatingSystem = UIDevice.current.systemVersion as String
        let appNamePortion: String
        if let named = appName {
            appNamePortion = "\nApp Name: \(named)"
        } else {
            appNamePortion = ""
        }
        return "\n\n\n\n\n\n\n\n\n\n\nPLEASE DO NOT DELETE THE FOLLOWING FROM EMAIL!!!\(appNamePortion)\nVersion: \(actualAppVersion)\nBuild: \(actualAppBuild)\nOperating System: \(actualOperatingSystem)\nDevice Name: \(actualDeviceName)"
    }
    open func showSendMailErrorAlert() {
        let alertController = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail. Please check e-mail configuration and try again.", preferredStyle: UIAlertController.Style.alert)
        let Dismiss = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        alertController.addAction(Dismiss)
        parentController.present(alertController, animated: true, completion: nil)
    }
    //MUST IMPLEMENT THIS ON EACH PARENT CONTROLLER, OTHERWISE CAN'T DISMISS
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
