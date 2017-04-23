//
//  CountryList.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import Foundation


class CountryList: InstantiatableFromResponse {
    var list: [CountryDetail]?

    required init?(_ response: AnyObject) {
        guard let response = response as? [[String: AnyObject]] else {
            return nil
        }

        list = response.flatMap {
            return CountryDetail($0 as AnyObject)
        }

    }

    convenience init() {
        let nilObject: [[String: AnyObject]] = [[:]]
        self.init(nilObject as AnyObject)!
    }
}
