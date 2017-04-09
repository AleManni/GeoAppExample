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
            population = "Population: \(Constants().stringMissing)"
        }

        if let regionString = country.region, let regionValue = country.region, regionValue.characters.count > 0 {
            region = regionString
        } else {
            region = "Region: \(Constants().stringMissing)"
        }

        flagImageURL = country.flagIconURL
    }
}

typealias CountryListRepresentable = [CountryRepresentable]

class CountryListViewModel {

    weak var delegate: viewModelDelegate?

    var loadedCountryList: CountryList?

    func loadData() {
        delegate?.viewModelIsLoading()
        let constructor = Factory(CountryList.self)
        ConnectionManager.fetch(endPoint: Endpoints.shared.all, constructor: constructor, callback: { (result, error) in
            if let result = result as? CountryList, let list = result.list {
                self.loadedCountryList = result
                let representableList = list.flatMap {
                    return CountryRepresentable($0)
                }
                DispatchQueue.main.async {
                self.delegate?.viewModelDidLoadData(data: representableList)
                }
            } else if let error = error {
                DispatchQueue.main.async {
                self.delegate?.viewModelDidFailWithError(error: error)
                }
            }
        })
    }
}
