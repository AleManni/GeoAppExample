//
//  String+Extensions.swift
//  ViagogoTest
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import Foundation

extension String {
    
    func localisedName(localisationDict: [String: String]?) -> String? {
        let countryLocale = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode)?.lowercaseString
        var localisedString: String?
        guard let dictionary = localisationDict else {return nil }
        for key in dictionary.keys {
            if key == countryLocale {
                localisedString = dictionary[key]!
            } else {
                localisedString = nil
            }
        }
        return localisedString
    }
}