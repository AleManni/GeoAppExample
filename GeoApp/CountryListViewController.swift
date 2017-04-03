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
        refreshControl.addTarget(self, action: #selector(CountryListViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        countriesTableView.register(UINib(nibName: "CountryListTableViewCell", bundle: nil), forCellReuseIdentifier: "countryCell")
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        countriesTableView.addSubview(refreshControl)
        title = "Countries"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.Colors().standardBlue, NSFontAttributeName: Constants.Fonts().titleLarge]
        populateDataSource()
    }

    func populateDataSource() {
        let constructor = Factory(Region.self)
        ConnectionManager.fetch(endPoint: Endpoints.shared.all, constructor: constructor, callback: { (result, error) in
            if let error = error {
                DispatchQueue.main.async{
                    ErrorHandler.handler.showError(error, sender: self)
                    self.indicator.stopAnimating()
                }
                return
            }
            if let result = result as? Region, let list = result.countryList {
                DispatchQueue.main.async {
                    self.dataSource = list
                    self.indicator.stopAnimating()
                }
            }
        })

    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.indicator.stopAnimating()
        populateDataSource()
        countriesTableView.reloadData()
        refreshControl.endRefreshing()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "detailViewSegue" else {return}
        let vc = segue.destination as! CountryDetailsViewController
      //  vc.country = selecteCountryDetail
    }
}


extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell") as! CountryListTableViewCell
        cell.populateWith(dataSource[indexPath.row])
        cell.formatCell()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selecteCountryDetail = dataSource[indexPath.row]
        self.performSegue(withIdentifier: "detailViewSegue", sender: self)
    }
}



