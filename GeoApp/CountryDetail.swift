//
//  File.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import Foundation

class CountryDetail: InstantiatableFromResponse {
    var name: String?
    var translations: [String:String]?
    var population: Int?
    var countryCode: String?
    var region: String?
    var flagIconURL: URL?
    var capital: String?
    var area: Int?
    var timeZones: [String]?
    var callingCodes: [String]?
    var currencies: [String]?
    var languages: [String]?
    var nativeName: String?
    var borders: [String]?

    required init?(_ response: AnyObject) {
        guard response is [String: AnyObject] else {
            return nil
        }
        capital = response["capital"] as? String
        area = response["area"] as? Int
        timeZones = response["timeZones"] as? [String]
        callingCodes = response["callingCodes"] as? [String]
        currencies = response["currencies"] as? [String]
        languages = response["languages"] as? [String]
        nativeName = response["nativeName"] as? String
        borders = response["borders"] as? [String]
        name = response["name"] as? String
        translations = response["translations"] as? [String: String]
        population = response["population"] as? Int
        region = response["region"] as? String
        if let altSpellings = response["altSpellings"] as? [String], !altSpellings.isEmpty {
            self.countryCode = altSpellings[0]
        }
        if let flagIcon = response["flag"] as? String {
            flagIconURL = URL(string:flagIcon)
        }
    }
}
