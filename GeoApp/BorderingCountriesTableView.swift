//
//  BorderingCountriesTableView.swift
//  GeoApp
//
//  Created by Alessandro Manni on 09/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation
import UIKit

protocol BorderingCountriesTableViewDelegate: class {
    func viewDidSelectCountry(countryName: String)
}

final class BorderingCountriesTableView: UIView {
    @IBOutlet weak var tableView: CountryListTableView!

    @IBOutlet weak var sectionTitleView: UIView!

    weak var delegate: BorderingCountriesTableViewDelegate?

    var data: CountryListRepresentable? {
        didSet {
            tableView.data = data
            tableView.setUpView()
            tableView.delegate = self
        }
    }

    var intrinsicHeight: CGFloat {
        let padding: CGFloat = 40
        return (tableView.intrinsicHeight + sectionTitleView.bounds.size.height + padding)
    }
}

    extension BorderingCountriesTableView: CountryListViewDelegate {
        func viewDidRequestDataUpdate() {

        }
        func viewDidSelectCountry(countryName: String) {
            delegate?.viewDidSelectCountry(countryName: countryName)
        }
        
}
