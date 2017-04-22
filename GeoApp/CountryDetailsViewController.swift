//
//  CountryDetails.swift
//  GeoApp
//
//  Created by Alessandro Manni on 14/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit


class CountryDetailsViewController: UIViewController {

    var selectedCountry: CountryDetail?
    var countries: [CountryDetail]? {
        didSet {
            self.selectedCountry = countries?.first(where: { $0.isSelected })
        }
    }

    lazy var rootView: CountryDetailsRootView = {
        self.view as! CountryDetailsRootView
    }()

    lazy var countryDetailsViewModel: CountryDetailsViewModel? = {
        if let selectedCountry = self.selectedCountry {
            let viewModel = CountryDetailsViewModel(country: selectedCountry)
            viewModel.delegate = self
            return viewModel
        } else {
            return nil
        }
    }()

    lazy var capitalCityViewModel: CapitalCityViewModel? = {
        if let selectedCountry = self.selectedCountry {
            let viewModel = CapitalCityViewModel(country: selectedCountry)
            viewModel.delegate = self
            return viewModel
        } else {
            return nil
        }
    }()

    lazy var countryRegionViewModel: RegionCountriesCollectionViewModel? = {
        if let region = self.selectedCountry?.region {
            let viewModel = RegionCountriesCollectionViewModel(region: region)
            viewModel.delegate = self
            return viewModel
        } else {
            return nil
        }
    }()

    lazy var borderingCountriesViewModel: BorderingCountriesViewModel? = {
        if let selectedCountry = self.selectedCountry {
            let viewModel = BorderingCountriesViewModel(country: selectedCountry)
            viewModel?.delegate = self
            return viewModel
        } else {
            return nil
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Colors.standardBlue, NSFontAttributeName: StyleManager.Fonts().titleLarge]
        setTitle()
        countryDetailsViewModel?.loadData()
        capitalCityViewModel?.loadData()
        countryRegionViewModel?.loadData()
        borderingCountriesViewModel?.loadData()
    }

    private func setTitle() {
        if let countryNameLocalised = selectedCountry?.name!.localisedName(self.selectedCountry?.translations) {
            title = countryNameLocalised
        } else {
            title = selectedCountry?.name ?? ""
        }
    }
}

extension CountryDetailsViewController: ViewModelDelegate {
    func viewModelIsLoading(viewModel: ViewModel) {

    }

    func viewModelDidLoadData<T>(data: T, viewModel: ViewModel) {
        switch viewModel {
        case is CountryDetailsViewModel:
            rootView.countryDetailsData = data as? CountryDetailsRepresentable
        case is  CapitalCityViewModel:
            rootView.capitalCityData = data as? CapitalCityRepresentable
        case is RegionCountriesCollectionViewModel:
            rootView.countryRegionCollectionData = data as? [CountryRegionRepresentable]
        case is BorderingCountriesViewModel:
            rootView.borderingCountriesData = data as? CountryListRepresentable
        default:
            break
        }
    }

    func viewModelDidFailWithError(error: Errors, viewModel: ViewModel) {

    }
}

extension CountryDetailsViewController: CountryListViewDelegate {
    func viewDidRequestDataUpdate() {
    }

    func viewDidSelectCountry(countryName: String) {
       // TO BE IMPLEMENTED
    }
}
