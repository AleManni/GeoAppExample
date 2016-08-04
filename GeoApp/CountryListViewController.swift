//
//  MainPageViewController.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class CountryListViewController: UIViewController {
    
    @IBOutlet weak var countriesTableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var dataSource: [CountryDetail] = [] {
        didSet {
            countriesTableView.reloadData()
        }
    }
    var selecteCountryDetail: CountryDetail?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(CountryListViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        countriesTableView.registerNib(UINib(nibName: "CountryListTableViewCell", bundle: nil), forCellReuseIdentifier: "countryCell")
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        countriesTableView.addSubview(refreshControl)
        title = "Countries"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.Colors().standardBlue, NSFontAttributeName: Constants.Fonts().titleLarge]
        populateDataSource()
    }
    
    func populateDataSource() {
        ConnectionManager.fetchAllCountries() { (callback) in
            guard callback.error == nil else {
                dispatch_async(dispatch_get_main_queue()){
                    ErrorHandler.handler.showError(callback.error!, sender: self)
                    self.indicator.stopAnimating()
                }
                return
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.dataSource = callback.response! as [CountryDetail]
                self.indicator.stopAnimating()
            }
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.indicator.stopAnimating()
        populateDataSource()
        countriesTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier == "detailViewSegue" else {return}
        let vc = segue.destinationViewController as! CountryDetailsViewController
        vc.country = selecteCountryDetail
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
        self.selecteCountryDetail = dataSource[indexPath.row]
        self.performSegueWithIdentifier("detailViewSegue", sender: self)
    }
}


