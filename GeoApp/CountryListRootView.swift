//
//  CountryListRootView.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation
import UIKit

protocol CountryListRootViewDelegate: class {
    func rootViewDidRequestDataUpdate()
    func rootViewDidSelectCountry(countryName: String)
}

class CountryListRootView: UIView {
    @IBOutlet weak var countriesTableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    weak var delegate: CountryListRootViewDelegate?


    var data: CountryListRepresentable = [] {
        didSet {
            countriesTableView.reloadData()
        }
    }

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(CountryListRootView.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()

    func setUpView() {
        countriesTableView.register(UINib(nibName: "CountryListTableViewCell", bundle: nil), forCellReuseIdentifier: "countryListCell")
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        countriesTableView.addSubview(refreshControl)
    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        indicator.stopAnimating()
        data = []
        delegate?.rootViewDidRequestDataUpdate()
    }
}

extension CountryListRootView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryListCell") as! CountryListTableViewCell
        cell.initiateWithData(data[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.rootViewDidSelectCountry(countryName: data[indexPath.row].name)
       // self.selecteCountryDetail = data[indexPath.row]
       // self.performSegue(withIdentifier: "detailViewSegue", sender: self)
    }
}


