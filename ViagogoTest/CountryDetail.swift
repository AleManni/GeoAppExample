//
//  File.swift
//  ViagogoTest
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import Foundation

class CountryDetail: Country {

var capital: String?
    var area: Int?
    var timeZones: [String]?
    var callingCodes: [String]?
    var currencies: [String]?
    var languages: [String]?
    var region: String?
    var borders: [String]?
    

    override func populateFromResponse(response: [String: AnyObject]) {
        super.populateFromResponse(response)
        if response["capital"] as? String != nil {
            capital = response["capital"] as? String
        }
        if response["area"] as? Int != nil {
            area = response["area"] as? Int
        }
        if response["timeZones"] as? [String] != nil {
            timeZones = response["timeZones"] as? [String]
        }
        if response["callingCodes"] as? [String] != nil {
            callingCodes = response["callingCodes"] as? [String]
        }
        if response["currencies"] as? [String] != nil {
            currencies = response["currencies"] as? [String]
        }
        if response["languages"] as? [String] != nil {
            languages = response["languages"] as? [String]
        }
        if response["region"] as? String != nil {
            region = response["region"] as? String
        }
        if response["borders"] as? [String] != nil {
            borders = response["borders"] as? [String]
        }
    }
}