//
//  CountryDetails.swift
//  GeoApp
//
//  Created by Alessandro Manni on 14/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit


class CountryDetailsViewController: UIViewController {

    var selectedCountry: CountryDetail? {
        didSet {
            guard let country = selectedCountry else {
                return
            }
            oldValue?.isSelected = false
            refreshViewModels(selectedContry: country)
            viewDidLoad()
        }
    }
    
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
            let viewModel = CountryDetailsViewModel(selectedCountry)
            viewModel.delegate = self
            return viewModel
        } else {
            return nil
        }
    }()

    lazy var capitalCityViewModel: CapitalCityViewModel? = {
        if let selectedCountry = self.selectedCountry {
            let viewModel = CapitalCityViewModel(selectedCountry)
            viewModel.delegate = self
            return viewModel
        } else {
            return nil
        }
    }()

    lazy var countryRegionViewModel: RegionCountriesCollectionViewModel? = {
        if let selectedCountry = self.selectedCountry {
            let viewModel = RegionCountriesCollectionViewModel(selectedCountry)
            viewModel.delegate = self
            return viewModel
        } else {
            return nil
        }
    }()

    lazy var borderingCountriesViewModel: BorderingCountriesViewModel? = {
        if let selectedCountry = self.selectedCountry {
            let viewModel = BorderingCountriesViewModel(selectedCountry)
            viewModel.delegate = self
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
        populateViewModels()
    }

    fileprivate func populateViewModels() {
        countryDetailsViewModel?.loadData()
        capitalCityViewModel?.loadData()
        countryRegionViewModel?.loadData()
        borderingCountriesViewModel?.loadData()
    }

    private func setTitle() {
        if let countryNameLocalised = selectedCountry?.name.localisedName(self.selectedCountry?.translations) {
            title = countryNameLocalised
        } else {
            title = selectedCountry?.name ?? ""
        }
    }

    private func refreshViewModels(selectedContry: CountryDetail) {
        countryDetailsViewModel?.swapSource(selectedContry)
        capitalCityViewModel?.swapSource(selectedContry)
        countryRegionViewModel?.swapSource(selectedContry.region)
        borderingCountriesViewModel?.swapSource(selectedContry)
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
        ErrorHandler.handler.showError(error, sender: self, delegate: self, buttonTitle: "Close")
    }
}

extension CountryDetailsViewController: CountryListViewDelegate {
    func viewDidRequestDataUpdate() {
    }

    func viewDidSelectCountry(countryName: String) {
        if let country = countries?.first(where: { $0.name == countryName }) {
            selectedCountry = country
        }
    }
}

extension CountryDetailsViewController: ErrorHandlerDelegate {
    func alertDidCancel() {
    }
}
