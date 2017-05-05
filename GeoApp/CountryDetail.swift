//
//  File.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import Foundation

class CountryDetail: InstantiatableFromResponse {
    let name: String
    let translations: [String: String]
    let population: Int
    var countryCode: String
    let region: String
    var flagIconURL: URL?
    let capital: String
    let area: Int
    let timeZones: [String]
    let callingCodes: [String]
    let currencies: [String]
    let languages: [String]
    let nativeName: String
    let borders: [String]
    var isSelected: Bool = false


    required init?(_ response: AnyObject) throws {
        guard response is [String: AnyObject],
            let name = response["name"] as? String,
            let population = response["population"] as? Int,
            let countryCode = response["alpha3Code"] as? String,
            let region = response["region"] as? String,
            let capital = response["capital"] as? String,
            let languagesDict = response["languages"] as? [[String: Any]],
            let callingCodes = response["callingCodes"] as? [String],
            let nativeName = response["nativeName"] as? String,
            let timeZones = response["timezones"] as? [String],
            var translations = response["translations"] as? [String: AnyObject?]
            else {
                throw Errors.jsonError
        }
        let currenciesDict = response["currencies"] as? [[String: Any]]
        let currencies = currenciesDict?.values(of: "name") as? [String] ?? []
        translations.forEach { if $0.value == nil { translations.removeValue(forKey: $0.key) } }

        self.name = name
        self.population = population
        self.countryCode = countryCode
        self.region = region
        self.capital = capital
        self.area = response["area"] as? Int ?? 0
        self.timeZones = timeZones
        self.nativeName = nativeName
        self.currencies = currencies
        self.callingCodes = callingCodes
        self.languages = languagesDict.values(of: "name") as? [String] ?? [""]
        self.translations = translations as! [String: String]
        self.borders = response["borders"] as? [String] ?? []

        if let altSpellings = response["altSpellings"] as? [String], !altSpellings.isEmpty {
            flagIconURL = URL(string: Endpoints.flagURLString(altSpellings[0]))
        }
    }

    init(name: String,
    translations: [String: String],
    population: Int,
    countryCode: String,
    region: String,
    flagIconURL: URL?,
    capital: String,
    area: Int,
    timeZones: [String],
    callingCodes: [String],
    currencies: [String],
    languages: [String],
    nativeName: String,
    borders: [String],
    isSelected: Bool = false
    ) {
    self.name = name
    self.translations = translations
    self.population = population
    self.countryCode = countryCode
    self.region = region
    self.flagIconURL = flagIconURL
    self.capital = capital
    self.area = area
    self.timeZones = timeZones
    self.callingCodes = callingCodes
    self.currencies = currencies
    self.languages = languages
    self.nativeName = nativeName
    self.borders = borders
    self.isSelected = isSelected
    }
}

extension CountryDetail: Equatable {
    static func == (lhs: CountryDetail, rhs: CountryDetail) -> Bool {
        return lhs.name == rhs.name &&
        lhs.translations == rhs.translations &&
        lhs.population == rhs.population &&
        lhs.countryCode == rhs.countryCode &&
        lhs.region == rhs.region &&
        lhs.flagIconURL == rhs.flagIconURL &&
        lhs.capital == rhs.capital &&
        lhs.area == rhs.area &&
        (lhs.timeZones ~ rhs.timeZones) &&
        (lhs.callingCodes ~ rhs.callingCodes) &&
        (lhs.currencies ~ rhs.currencies) &&
        (lhs.languages ~ rhs.languages) &&
        lhs.nativeName == rhs.nativeName &&
        (lhs.borders ~ rhs.borders) &&
        lhs.isSelected == rhs.isSelected
    }
}
