//
//  CountryListViewModel.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation
import UIKit

struct CountryRepresentable {
    let name: String
    let population: String
    let region: String
    let flagImageURL: URL?

    init?(_ country: CountryDetail) {

        guard let nameString = country.name else {
            return nil
        }

        if let countryNameLocalised = nameString.localisedName(country.translations) {
            name = countryNameLocalised
        } else {
            name = nameString
        }

        if let populationInt = country.population, let value = country.population, value != 0 {
            let populationByMillions = Double(populationInt)/1000000
            population = "Population: \(populationByMillions)M"
        } else {
            population = "Population: \(StyleManager.shared.stringMissing)"
        }

        if let regionString = country.region, let regionValue = country.region, regionValue.characters.count > 0 {
            region = regionString
        } else {
            region = "Region: \(StyleManager.shared.stringMissing)"
        }

        flagImageURL = country.flagIconURL
    }
}

typealias CountryListRepresentable = [CountryRepresentable]

final class CountryListViewModel: ViewModel {

    weak var delegate: ViewModelDelegate?

    private(set) var loadedCountryList: CountryList?

    init(countryList: CountryList?) {
        self.loadedCountryList = countryList
    }

    func loadData() {
        if let countryList = loadedCountryList?.list, !countryList.isEmpty {
            let representableList = countryList.flatMap {
                return CountryRepresentable($0)
            }
            self.delegate?.viewModelDidLoadData(data: representableList, viewModel: self)
            return
        }

        delegate?.viewModelIsLoading(viewModel: self)

        Store.shared.fetchAll(completion: { result in
            switch result {
            case .success(let countryList):
            if let countryList = countryList as? CountryList, let list = countryList.list {
                let representableList = list.flatMap {
                    return CountryRepresentable($0)
                }
                DispatchQueue.main.async {
                self.delegate?.viewModelDidLoadData(data: representableList, viewModel: self)
                }
            }
            case .error(let error):
                DispatchQueue.main.async {
                self.delegate?.viewModelDidFailWithError(error: error, viewModel: self)
                }
            }
        })
    }

    func refreshData() {
        loadedCountryList = nil
        loadData()
    }

    func resetSectedState() {
        loadedCountryList?.list?.forEach({ $0.isSelected = false })
    }
}
