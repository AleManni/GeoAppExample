//
//  BorderingCountriesTableView.swift
//  GeoApp
//
//  Created by Alessandro Manni on 09/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation
import UIKit

final class BorderingCountriesTableView: UIView {
    @IBOutlet weak var tableView: CountryListTableView!

    var data: CountryListRepresentable? {
        didSet {
            tableView.data = data
            tableView.setUpView()
            tableView.delegate = self
        }
    }

    var intrinsicHeight: CGFloat {
        return tableView.intrinsicHeight
    }
}

    extension BorderingCountriesTableView: CountryListViewDelegate {
        func viewDidRequestDataUpdate() {

        }
        func viewDidSelectCountry(countryName: String) {
            
        }
        
}
