//
//  CountryDetailsViewModel.swift
//  GeoApp
//
//  Created by Alessandro Manni on 09/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

struct CountryDetailsRepresentable {
    let flagImageURL: URL?
    let nativeName: String
    let population: String
    let languages: String
    let currency: String
    let phoneLabel: String
    let timeZone: String

    init(_ country: CountryDetail) {

        nativeName = country.nativeName ?? "\(StyleManager.shared.stringMissing)"

        if let population = country.population {
            let populationByMillions = Double(population)/1000000
            self.population = "Population: \(populationByMillions)M"
        } else {
            population = "Population: \(StyleManager.shared.stringMissing)"
        }

        flagImageURL = country.flagIconURL

        if let languages = country.languages, !languages.isEmpty {
            self.languages = String().composeFromArray(languages).uppercased()
        } else {
            languages = StyleManager.shared.stringMissing
        }

        if let callingCodes = country.callingCodes, !callingCodes.isEmpty {
            phoneLabel = String().composeFromArray(callingCodes)
        } else {
            phoneLabel = (StyleManager.shared.stringMissing)
        }

        if let timeZones = country.timeZones, !timeZones.isEmpty {
            timeZone = String().composeFromArray(timeZones)
        } else {
            timeZone = StyleManager.shared.stringMissing
        }

        if let currencies = country.currencies, !currencies.isEmpty {
            currency = String().composeFromArray(currencies)
        } else {
            currency = StyleManager.shared.stringMissing
        }
    }
}

final class CountryDetailsViewModel: ViewModel {

    weak var delegate: ViewModelDelegate?
    var country: CountryDetail
    
    init(country: CountryDetail) {
        self.country = country
    }
    
    func loadData() {
        let representableCountryDetails = CountryDetailsRepresentable(country)
        self.delegate?.viewModelDidLoadData(data: representableCountryDetails, viewModel: self)
    }    
}
