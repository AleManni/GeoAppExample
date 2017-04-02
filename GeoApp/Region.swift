//
//  Region.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import Foundation


class Region: InstantiatableFromResponse {
    var countryList: [CountryDetail]?

    required init?(_ response: AnyObject) {
        guard let response = response as? [[String: AnyObject]] else {
            return nil
        }
        var listOfCountries: [CountryDetail] = []
        if !response.isEmpty {
            for item in response {
                if let country = CountryDetail(item as AnyObject) {
                listOfCountries.append(country)
                }
            }
            countryList = listOfCountries
        }
    }
}
