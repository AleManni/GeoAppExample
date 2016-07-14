//
//  MainPageViewController.swift
//  ViagogoTest
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class CountryListViewController: UIViewController {
    
    @IBOutlet weak var countriesTableView: UITableView!
    var dataSource: [Country] = [] {
        didSet {
            countriesTableView.reloadData()
        }
    }
    var selecteCountry: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countriesTableView.registerNib(UINib(nibName: "CountryListTableViewCell", bundle: nil), forCellReuseIdentifier: "countryCell")
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        populateDataSource()
        title = "Country List"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.Colors().standardBlue, NSFontAttributeName: Constants.Fonts().titleLarge]
    }
    
    func populateDataSource() {
        ConnectionManager.fetchAllCountries() { (callback) in
            guard callback.error == nil else {
                ErrorHandler.handler.showError(callback.error!, sender: self)
                return
            }
            self.dataSource = callback.response! as [Country]
        }
    }
    
    
    func displayView() {
        
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }    
}

extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("countryCell") as! CountryListTableViewCell
        cell.populateWith(dataSource[indexPath.row])
        cell.formatCell()
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selecteCountry = dataSource[indexPath.row]
        performSegueWithIdentifier("detailViewSegue", sender: self)
    }
    
}



