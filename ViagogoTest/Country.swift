//
//  CountryOverview.swift
//  ViagogoTest
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import Foundation

class Country {
    var name: String?
    var translations: [String:String]?
    var population: Int?
    var countryCode: String?
    var region: String?
    var flagIconURL: NSURL?
    
    
    func populateFromResponse(response: [String: AnyObject]) {
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

