//
//  MOBTableViewController.swift
//  MOBCore
//
//  Created by Jason Morcos on 12/4/15.
//  Copyright © 2017 Moballo, LLC. All rights reserved.
//

import UIKit

@objc open class MOBTableViewController: UITableViewController {
    fileprivate var statusLabelView: UILabel?
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.keyboardDismissMode = .interactive
        self.edgesForExtendedLayout = UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars = false
        self.definesPresentationContext = true
        self.automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            self.navigationItem.hidesSearchBarWhenScrolling = true
        }
        
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
            constraints.append(NSLayoutConstraint(item: searchLabel, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0))
            constraints.append(NSLayoutConstraint(item: searchLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: topPadding))
            constraints.append(NSLayoutConstraint(item: searchLabel, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: topPadding))
            constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|->=padding-[statusLabel(<=maxWidth)]->=padding-|", options: NSLayoutConstraint.FormatOptions(), metrics: ["padding" : 15, "maxWidth" : 290], views: ["statusLabel" : searchLabel]))
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
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.deselectAllCells()
    }
}

open class MOBTableViewControllerWithSearch: MOBTableViewController, UISearchControllerDelegate, UISearchResultsUpdating {
    public var searchController = UISearchController(searchResultsController: nil)
    fileprivate var privateSearchEnabled = false;
    fileprivate var hideSearchBarWhileScrolling = true;
    public var searchEnabled: Bool {
        return self.privateSearchEnabled;
    }
    public var searchBar: UISearchBar {
        return self.searchController.searchBar;
    }
    open func filterSearchResults(searchTerm: String?) {
        //OVERRIDE IN SUBCLASS
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchController()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 11.0, *), searchController.searchBar.frame.height == 0 {
            navigationItem.searchController?.isActive = false
        }
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
    }
    
    public func enableSearch() {
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = self.searchController
        } else {
            self.tableView.tableHeaderView = self.searchBar
        }
        self.privateSearchEnabled = true
    }
    public func disableSearch() {
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = nil
        } else {
            self.tableView.tableHeaderView = nil
            //self.navigationItem.titleView = nil
        }
        self.privateSearchEnabled = false;
    }
    fileprivate func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        if #available(iOS 11.0, *) {
            self.searchController.hidesNavigationBarDuringPresentation = true
        } else {
            self.searchController.hidesNavigationBarDuringPresentation = false
        }
        if #available(iOS 9.1, *) {
            self.searchController.obscuresBackgroundDuringPresentation = false
        }
        self.searchController.definesPresentationContext = false
        if #available(iOS 13.0, *) {
            self.searchController.automaticallyShowsCancelButton = true
        }
    }
    public func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return self.searchBar.isEmpty
    }
    
    public func willDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = searchController.isActive;
    }
    public func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = searchController.isActive;
    }
    
    public var isSearching: Bool {
        return self.searchEnabled && self.searchController.isActive
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        filterSearchResults(searchTerm: searchController.searchBar.text)
        searchController.searchBar.showsCancelButton = searchController.isActive;
    }
}
