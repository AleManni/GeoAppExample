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
            self.capital = country.capital
            self.region = country.region
    }
}


final class CapitalCityViewModel: ViewModel {
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
        let representableCapitalCity = CapitalCityRepresentable(country)
        self.delegate?.viewModelDidLoadData(data: representableCapitalCity, viewModel: self)
    }
}
