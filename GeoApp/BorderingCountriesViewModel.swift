   //
   //  BorderingCountriesViewModel.swift
   //  GeoApp
   //
   //  Created by Alessandro Manni on 09/04/2017.
   //  Copyright © 2017 Alessandro Manni. All rights reserved.
   //

   import Foundation

   final class BorderingCountriesViewModel: ViewModel {
    var country: CountryDetail {
        didSet {
            if let countries = Store.shared.countries?.list {
                let countryBorders = country.borders ?? []
                var countriesArray: [CountryDetail] = []
                countryBorders.forEach { countryCode in
                    if let country = countries.first(where: { $0.countryCode == countryCode }) {
                        countriesArray.append(country)
                    }
                }
                self.borderingCountries = countriesArray
            }
        }
    }
    private var borderingCountries: [CountryDetail]?
    weak var delegate: ViewModelDelegate?

    init(country: CountryDetail) {
        self.country = country
    }

    func loadData() {
        if let borderingCountries = borderingCountries {
            let representableList = borderingCountries.flatMap {
                return CountryRepresentable($0)
            }
            self.delegate?.viewModelDidLoadData(data: representableList, viewModel: self)
        }
    }
    
   }
