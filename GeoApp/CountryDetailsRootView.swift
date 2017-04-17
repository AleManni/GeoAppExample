//
//  CountryDetailsRootView.swift
//  GeoApp
//
//  Created by Alessandro Manni on 09/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation
import UIKit

final class CountryDetailsRootView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var countryDetailsView: CountryDetailsView!
    @IBOutlet weak var capitalCityView: CapitalCityView!
    @IBOutlet weak var regionDetailView: RegionCollectionView!
    @IBOutlet weak var neighbouringCountriesView: CountryListTableView!

    @IBOutlet weak var regionDetailViewHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var neighbouringCountriesViewHeightConstr: NSLayoutConstraint!

    weak var delegate: CountryListViewDelegate?

    func setUpSubViews() {

    }

    var countryDetailsData: CountryDetailsRepresentable? {
        didSet {
            countryDetailsView.initiate(data: countryDetailsData)
        }
    }

    var capitalCityData: CapitalCityRepresentable? {
        didSet {
            capitalCityView.initiate(data: capitalCityData)
        }
    }

    var countryRegionCollectionData: [CountryRegionRepresentable]? {
        didSet {
            regionDetailView.data = countryRegionCollectionData
        }
    }

    var borderingCountriesData: [CountryRepresentable]? {
        didSet {
            neighbouringCountriesView.delegate = self
            neighbouringCountriesView.setUpView()
            neighbouringCountriesView.data = borderingCountriesData
        }
    }
}

extension CountryDetailsRootView: CountryListViewDelegate {
    func viewDidRequestDataUpdate() {
        delegate?.viewDidRequestDataUpdate()
    }

    func viewDidSelectCountry(countryName: String) {
        delegate?.viewDidSelectCountry(countryName: countryName)
    }
}
