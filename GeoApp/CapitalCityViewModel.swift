//
//  CapitalCityViewModel.swift
//  GeoApp
//
//  Created by Alessandro Manni on 09/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

struct CapitalCityRepresentable {
    let capital: String
    let region: String

    init(_ country: CountryDetail) {
        if let capital = country.capital {
            self.capital = capital
        } else {
            self.capital = StyleManager.shared.stringMissing
        }

        if let region = country.region {
            self.region = region
        } else {
            self.region = StyleManager.shared.stringMissing
        }
    }
}


final class CapitalCityViewModel: ViewModel {

    weak var delegate: ViewModelDelegate?
    var country: CountryDetail

    init(country: CountryDetail) {
        self.country = country
    }

    func loadData() {
        let representableCapitalCity = CapitalCityRepresentable(country)
        self.delegate?.viewModelDidLoadData(data: representableCapitalCity, viewModel: self)
    }
}
