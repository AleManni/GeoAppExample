//
//  String+Extensions.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import Foundation

extension String {
    
    func localisedName(_ localisationDict: [String: String?]?) -> String? {
        let languageLocale = ((Locale.current as NSLocale).object(forKey: NSLocale.Key(rawValue: Locale.preferredLanguages[0])) as AnyObject).lowercased
        var localisedString: String?
        guard let dictionary = localisationDict else {
            return nil
        }
        let stringKey = dictionary.keys.first(where: {
            $0 == languageLocale
        })
        if let key = stringKey, let string = dictionary[key] {
            localisedString = string
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
