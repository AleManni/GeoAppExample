//
//  String+Extensions.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import Foundation

extension String {
    
    func localisedName(_ localisationDict: [String: String]?) -> String? {
        let languageLocale = ((Locale.current as NSLocale).object(forKey: NSLocale.Key(rawValue: Locale.preferredLanguages[0])) as AnyObject).lowercased
        var localisedString: String?
        guard let dictionary = localisationDict else {return nil }
        for key in dictionary.keys {
            if key == languageLocale {
                localisedString = dictionary[key]!
                return localisedString
            } else {
                localisedString = nil
            }
        }
        return localisedString
    }
    
    func composeFromArray(_ array: [String]) -> String {
        var newString = ""
        for item in array {
        newString = newString + item
            if newString != "" && item != array.last {
               newString = newString + " "
            }
        }
        return newString
    }
}