//
//  Region.swift
//  ViagogoTest
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import Foundation


class Region {
    var countryList: [CountryDetail]?
    
    func populateFromResponse(response: [[String: AnyObject]]) {
        var listOfCountries: [CountryDetail] = []
        if !response.isEmpty {
            for item in response {
                let country = CountryDetail()
                country.populateFromResponse(item)
                listOfCountries.append(country)
            }
            countryList = listOfCountries
        }
    }
}
