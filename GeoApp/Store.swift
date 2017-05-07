//
//  Store.swift
//  GeoApp
//
//  Created by Alessandro Manni on 17/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

class Store {
    static let shared = Store()
    private(set) var countries: CountryList = CountryList()

    func fetchAll(completion: @escaping (Result) -> Void) {
        clear()
        
        NetworkManager.fetchCountryList(completion: { result in
            switch result {
            case .success(let countryList):
                if let countryList = countryList as? CountryList {
                    self.countries = countryList
                    completion(.success(countryList))
                    }
            case .failure(let error):
                    completion(.failure(error))
                }
            })
        }

    func clear() {
    countries.list?.removeAll()
    }
}

// TODO: Implement data persistency (NSCoding/CoreData/Realm)
