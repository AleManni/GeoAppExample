   //
   //  BorderingCountriesViewModel.swift
   //  GeoApp
   //
   //  Created by Alessandro Manni on 09/04/2017.
   //  Copyright © 2017 Alessandro Manni. All rights reserved.
   //

   import Foundation

   final class BorderingCountriesViewModel: ViewModel {
    private let borderingCountries: [CountryDetail]
    weak var delegate: ViewModelDelegate?

    init?(country: CountryDetail) {
        if let countries = Store.shared.countries?.list {
            let countryBorders = country.borders ?? []
            var countriesArray: [CountryDetail] = []
            countryBorders.forEach { countryCode in
                if let country = countries.first(where: { $0.countryCode == countryCode }) {
                    countriesArray.append(country)
                }
            }
            borderingCountries = countriesArray
        } else {
            return nil
        }
    }

    func loadData() {
        let representableList = borderingCountries.flatMap {
            return CountryRepresentable($0)
        }
        self.delegate?.viewModelDidLoadData(data: representableList, viewModel: self)
    }
}
