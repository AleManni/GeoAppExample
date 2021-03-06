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

        nativeName = country.nativeName

        let populationByMillions = Double(country.population)/1000000
        let stringRepresentable = String(format: "%.3f", populationByMillions)
        self.population = "Population: \(stringRepresentable)M"

        flagImageURL = country.flagIconURL

        if !country.languages.isEmpty {
            self.languages = country.languages.joined(separator: " ").uppercased()
        } else {
            languages = StyleManager.shared.stringMissing
        }

        if !country.callingCodes.isEmpty {
            phoneLabel = country.callingCodes.joined(separator: " ")
        } else {
            phoneLabel = (StyleManager.shared.stringMissing)
        }

        if !country.timeZones.isEmpty {
            timeZone = country.timeZones.joined(separator: " ")
        } else {
            timeZone = StyleManager.shared.stringMissing
        }

        if !country.currencies.isEmpty {
            currency = country.currencies.joined(separator: " ")
        } else {
            currency = StyleManager.shared.stringMissing
        }
    }
}

final class CountryDetailsViewModel: ViewModel {

    weak var delegate: ViewModelDelegate?
    private var country: CountryDetail {
        didSet {
        loadData()
        }
    }

    init(_ data: InstantiatableFromResponse) {
        self.country = data as! CountryDetail
    }

    func swapSource(_ country: CountryDetail) {
        self.country = country
    }
    
    func loadData() {
        let representableCountryDetails = CountryDetailsRepresentable(country)
        self.delegate?.viewModelDidLoadData(data: representableCountryDetails, viewModel: self)
    }    
}
