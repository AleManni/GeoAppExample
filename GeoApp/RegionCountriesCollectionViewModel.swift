//
//  CountryRegionCollectionViewModel.swift
//  GeoApp
//
//  Created by Alessandro Manni on 09/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

struct CountryRegionRepresentable {
    let countryCode: String
    let flagImageURL: URL?
    let regionName: String?

    init?(_ country: CountryDetail) {
        guard let countryCode = country.countryCode else {
            return nil
        }
        self.countryCode = countryCode.uppercased()
        flagImageURL = country.flagIconURL
        if let region = country.region {
        regionName = region.uppercased() + " COUNTRIES:"
        } else {
            regionName = ""
        }
    }
}


final class RegionCountriesCollectionViewModel: ViewModel {

    typealias T = CountryDetail
    private var regionName: String?
    weak var delegate: ViewModelDelegate?

    init<T>(_ data: T) where T : InstantiatableFromResponse {
        let data = data as! CountryDetail
        regionName = data.region
    }
 
    func swapSource(_ region: String) {
        regionName = region
    }

    func loadData() {
        guard let regionName = regionName else {
            return
        }
        delegate?.viewModelIsLoading(viewModel: self)
        let constructor = Factory(CountryList.self)
        ConnectionManager.fetch(endPoint: Endpoints.shared.region(regionName), constructor: constructor, callback: { result in
            switch result {
            case .success(let countries):
            if let countries = countries as? CountryList, let list = countries.list {
                let representableList = list.flatMap {
                    return CountryRegionRepresentable($0)
                }
                DispatchQueue.main.async {
                    self.delegate?.viewModelDidLoadData(data: representableList, viewModel: self)
                }
            }
                return
            case .error(let error):
                DispatchQueue.main.async {
                    self.delegate?.viewModelDidFailWithError(error: error, viewModel: self)
                }
            }
        })
    }
}
