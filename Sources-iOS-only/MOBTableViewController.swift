//
//  MOBTableViewController.swift
//  MOBCore
//
//  Created by Jason Morcos on 12/4/15.
//  Copyright © 2017 Moballo, LLC. All rights reserved.
//

import UIKit

class MOBTableViewController: UITableViewController {
    var searchTableViewStatusMessageLabel: UILabel?
    var statusMessageAlreadySet = "No Results Found"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.keyboardDismissMode = .interactive
        searchTableViewStatusMessageLabel = UILabel()
        if let searchLabel = searchTableViewStatusMessageLabel {
            searchLabel.text = "No Results Found";
            searchLabel.textColor = blueColor
            searchLabel.textAlignment = .center;
            searchLabel.font = UIFont.boldSystemFont(ofSize: 18)
            searchLabel.numberOfLines = 0;
            searchLabel.backgroundColor = UIColor.clear
            self.view.addSubview(searchLabel)
            searchLabel.isHidden = true
            searchLabel.translatesAutoresizingMaskIntoConstraints = false;
            var constraints = [NSLayoutConstraint]()
            constraints.append(NSLayoutConstraint(item: searchLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0))
            constraints.append(NSLayoutConstraint(item: searchLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 55.0))
            constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|->=padding-[statusLabel(<=maxWidth)]->=padding-|", options: NSLayoutFormatOptions(), metrics: ["padding" : 15, "maxWidth" : 290], views: ["statusLabel" : searchLabel]))
            self.view.addConstraints(constraints)
        }
        
    }
    func setTableViewStatusMessage(_ message: String) {
        statusMessageAlreadySet = message
    }
    func showTableViewStatusMessage() {
        if let searchLabel = searchTableViewStatusMessageLabel {
            searchLabel.isHidden = false
        }
    }
    func hideTableViewStatusMessage() {
        if let searchLabel = searchTableViewStatusMessageLabel {
            searchLabel.isHidden = true
        }
    }
}
