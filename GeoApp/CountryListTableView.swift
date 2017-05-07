//
//  CountryListTableView.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation
import UIKit

protocol CountryListViewDelegate: class {
    func viewDidRequestDataUpdate()
    func viewDidSelectCountry(countryName: String)
}

class CountryListTableView: UIView {
    @IBOutlet weak var countriesTableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    weak var delegate: CountryListViewDelegate?

    var data: CountryListRepresentable? {
        didSet {
            countriesTableView.reloadData()
        }
    }

    var intrinsicHeight: CGFloat {
        return CGFloat(tableView(countriesTableView, numberOfRowsInSection: 0) * 120)
    }

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(CountryListTableView.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()

    func setUpView() {
        countriesTableView.register(UINib(nibName: "CountryListTableViewCell", bundle: nil), forCellReuseIdentifier: "countryListCell")
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        countriesTableView.addSubview(refreshControl)
        countriesTableView.accessibilityIdentifier = "countryListTableView"
    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        indicator.stopAnimating()
        data = []
        delegate?.viewDidRequestDataUpdate()
    }
}

extension CountryListTableView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryListCell") as! CountryListTableViewCell
        if let country = data?[indexPath.row] {
        cell.initiateWithData(country)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let country = data?[indexPath.row] {
        delegate?.viewDidSelectCountry(countryName: country.name)
        }
    }
}


