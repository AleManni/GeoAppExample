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
    @IBOutlet weak var sectionTitleViewLabel: UILabel!

    weak var delegate: BorderingCountriesTableViewDelegate?

    private var areBordersAvailable: Bool = false {
        didSet {
            switch areBordersAvailable {
            case true:
                tableView.data = data
                tableView.setUpView()
                tableView.delegate = self
                sectionTitleViewLabel.text = "Bordering Countries"
                break
            case false:
                sectionTitleViewLabel.text = "No Bordering Countries"
                break
            }
        }
    }

    var data: CountryListRepresentable? {
        didSet {
            if let data = data {
                areBordersAvailable = data.count > 0
            }
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
