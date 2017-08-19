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

    required init?(_ response: Any) throws {
        guard let response = response as? [[String: Any]] else {
                throw Errors.jsonError
            }

        list = try response.flatMap {
            return try CountryDetail($0 as Any)
        }
    }

    init() {
        list = []
    }
}
