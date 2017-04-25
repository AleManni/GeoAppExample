//
//  File.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import Foundation

class CountryDetail: InstantiatableFromResponse {
    let name: String?
    let translations: [String:String]?
    let population: Int?
    var countryCode: String?
    let region: String?
    var flagIconURL: URL?
    let capital: String?
    let area: Int?
    let timeZones: [String]?
    let callingCodes: [String]?
    let currencies: [String]?
    let languages: [String]?
    let nativeName: String?
    let borders: [String]?
    var isSelected: Bool = false

    required init?(_ response: AnyObject) {
        guard response is [String: AnyObject] else {
            return nil
        }
        capital = response["capital"] as? String
        area = response["area"] as? Int
        timeZones = response["timezones"] as? [String]
        callingCodes = response["callingCodes"] as? [String]
        let currenciesDict = response["currencies"] as? [[String: Any]]
        currencies = currenciesDict?.values(of: "name") as? [String]
        let languagesDict = response["languages"] as? [[String: Any]]
        languages = languagesDict?.values(of: "name") as? [String]
        nativeName = response["nativeName"] as? String
        borders = response["borders"] as? [String]
        name = response["name"] as? String
        translations = response["translations"] as? [String: String]
        population = response["population"] as? Int
        region = response["region"] as? String
        if let altSpellings = response["altSpellings"] as? [String], !altSpellings.isEmpty {
        flagIconURL = URL(string: Endpoints.flagURLString(altSpellings[0]))
        }
        countryCode = response["alpha3Code"] as? String
    }
}
