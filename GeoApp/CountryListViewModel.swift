//
//  CountryListViewModel.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation
import UIKit

typealias CountryListRepresentable = [CountryRepresentable]

struct CountryRepresentable {
    let name: String
    let population: String
    let region: String
    let flagImageURL: URL?

    init?(_ country: CountryDetail) {

        if let countryNameLocalised = country.name.localisedName(country.translations) {
            name = countryNameLocalised
        } else {
            name = country.name
        }

        if country.population != 0 {
            let populationByMillions = Double(country.population)/1000000
            let stringRepresentable = String(format: "%.3f", populationByMillions)
            population = "Population: \(stringRepresentable)M"
        } else {
            population = "Population: \(StyleManager.shared.stringMissing)"
        }

        if country.region.characters.count > 0 {
            region = country.region
        } else {
            region = "Region: \(StyleManager.shared.stringMissing)"
        }

        flagImageURL = country.flagIconURL
    }
}

final class CountryListViewModel: ViewModel {

    init(_ data: InstantiatableFromResponse) {
        self.loadedCountryList = data as? CountryList
    }

    weak var delegate: ViewModelDelegate?

    private(set) var loadedCountryList: CountryList? {
        didSet {
            loadData()
        }
    }

    func loadData() {
        delegate?.viewModelIsLoading(viewModel: self)
        if let countryList = loadedCountryList?.list, !countryList.isEmpty {
            let representableList = countryList.flatMap {
                return CountryRepresentable($0)
            }
            self.delegate?.viewModelDidLoadData(data: representableList, viewModel: self)
            return
        } else {
            refreshStore()
        }
    }

    private func refreshStore() {
        Store.shared.fetchAll(completion: { result in
            switch result {
            case .success(let countryList):
                if let countryList = countryList as? CountryList {
                    self.loadedCountryList = countryList
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.viewModelDidFailWithError(error: error, viewModel: self)
                }
            }
        })
    }

    func refreshData() {
        refreshStore()
    }

    func resetSelectedState() {
        loadedCountryList?.list?.forEach({ $0.isSelected = false })
    }
}
