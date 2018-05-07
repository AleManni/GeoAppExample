   //
   //  BorderingCountriesViewModel.swift
   //  GeoApp
   //
   //  Created by Alessandro Manni on 09/04/2017.
   //  Copyright © 2017 Alessandro Manni. All rights reserved.
   //

   import Foundation

   final class BorderingCountriesViewModel: ViewModel {

    private var country: CountryDetail
    private var borderingCountries: [CountryDetail]?
    weak var delegate: ViewModelDelegate?

    init(_ data: InstantiatableFromResponse) {
        self.country = data as! CountryDetail
    }

    func loadData() {
        if let countries = Store.shared.countries.list, countries.count > 0 {
            populate(with: countries)
        } else {
            Store.shared.fetchAll() { result in
                switch result {
                case .success:
                    self.populate(with: Store.shared.countries.list!)
                    return
                case let .failure(error):
                    self.delegate?.viewModelDidFailWithError(error: error, viewModel: self)
                    return
                }
            }
        }
    }

    private func populate(with countries: [CountryDetail]) {
        let countryBorders = country.borders
        var countriesArray: [CountryDetail] = []
        countryBorders.forEach { countryCode in
            if let country = countries.first(where: { $0.countryCode == countryCode }) {
                countriesArray.append(country)
            }
        }
        self.borderingCountries = countriesArray
        if let borderingCountries = borderingCountries {
          let representableList = borderingCountries.compactMap {
                return CountryRepresentable($0)
            }
            self.delegate?.viewModelDidLoadData(data: representableList, viewModel: self)
        }
    }

    func swapSource(_ country: CountryDetail) {
        self.country = country
        loadData()
    }
    
   }
