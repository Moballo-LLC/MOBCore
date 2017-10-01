//
//  MOBTableViewController.swift
//  MOBCore
//
//  Created by Jason Morcos on 12/4/15.
//  Copyright © 2017 Moballo, LLC. All rights reserved.
//

import UIKit

open class MOBTableViewController: UITableViewController {
    fileprivate var statusLabelView: UILabel?
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.keyboardDismissMode = .interactive
        statusLabelView = UILabel()
        if let searchLabel = statusLabelView {
            searchLabel.text = ""
            searchLabel.textColor = UIColor.black
            searchLabel.textAlignment = .center
            searchLabel.font = UIFont.boldSystemFont(ofSize: 18)
            searchLabel.numberOfLines = 0;
            searchLabel.backgroundColor = UIColor.clear
            self.view.addSubview(searchLabel)
            searchLabel.isHidden = true
            searchLabel.translatesAutoresizingMaskIntoConstraints = false;
            let topPadding:CGFloat
            if UIApplication.isExtension {
                topPadding = max(5, (self.tableView.rowHeight-searchLabel.frame.height)/2)
            } else {
                topPadding = 55.0
            }
            var constraints = [NSLayoutConstraint]()
            constraints.append(NSLayoutConstraint(item: searchLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0))
            constraints.append(NSLayoutConstraint(item: searchLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: topPadding))
            constraints.append(NSLayoutConstraint(item: searchLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: topPadding))
            constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|->=padding-[statusLabel(<=maxWidth)]->=padding-|", options: NSLayoutFormatOptions(), metrics: ["padding" : 15, "maxWidth" : 290], views: ["statusLabel" : searchLabel]))
            self.view.addConstraints(constraints)
        }
        
    }
    public func setStatusLabelColor(_ color: UIColor) {
        if let searchLabel = statusLabelView {
            searchLabel.textColor = color
        }
    }
    public func showStatusLabel(message: String, color: UIColor? = nil) {
        if let searchLabel = statusLabelView {
            searchLabel.text = message
            searchLabel.isHidden = false
            if let desiredColor = color {
                searchLabel.textColor = desiredColor
            }
        }
    }
    public func hideStatusLabel() {
        if let searchLabel = statusLabelView {
            searchLabel.isHidden = true
        }
    }
}
