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
        let languageLocale = NSLocale.currentLocale().objectForKey(NSLocale.preferredLanguages()[0])?.lowercaseString
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
    
    func composeFromArray(array: [String])-> String {
        var newString = ""
        for item in array {
        newString = newString.stringByAppendingString(item)
            if newString != "" {
               newString = newString.stringByAppendingString(" ")
            }
        }
        return newString
    }
}