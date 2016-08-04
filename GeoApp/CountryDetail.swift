//
//  File.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import Foundation

class CountryDetail {
    var name: String?
    var translations: [String:String]?
    var population: Int?
    var countryCode: String?
    var region: String?
    var flagIconURL: NSURL?
    var capital: String?
    var area: Int?
    var timeZones: [String]?
    var callingCodes: [String]?
    var currencies: [String]?
    var languages: [String]?
    var nativeName: String?
    var borders: [String]?
    
    
    func populateFromResponse(response: [String: AnyObject]) {
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
        if response["nativeName"] as? String != nil {
            nativeName = response["nativeName"] as? String
        }
        if response["borders"] as? [String] != nil {
            borders = response["borders"] as? [String]
        }
        if response["name"] as? String != nil {
            name = response["name"] as? String
        }
        if response["translations"] as? [String: String] != nil {
            translations = response["translations"] as? [String: String]
        }
        if response["population"] as? Int != nil {
            population = response["population"] as? Int
        }
        if response["region"] as? String != nil {
            region = response["region"] as? String
        }
        if response["altSpellings"] as? [String] != nil {
            countryCode = response["altSpellings"]![0] as? String
            flagIconURL = NSURL(string: "http://www.geonames.org/flags/x/\(countryCode!.lowercaseString).gif")
        }
    }
}