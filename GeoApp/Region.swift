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

        countryList = response.flatMap {
            return CountryDetail($0 as AnyObject)
        }
    }
}
