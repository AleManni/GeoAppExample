//
//  MockObjects.swift
//  GeoApp
//
//  Created by Alessandro Manni on 05/05/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation
@testable import GeoApp

class MockObjects {
    static let shared = MockObjects()

    let Afghanistan = CountryDetail(name: "Afghanistan",
                                    translations: ["de": "Afghanistan",
                                                   "es": "Afganistán",
                                                   "fr": "Afghanistan",
                                                   "ja": "アフガニスタン",
                                                   "it": "Afghanistan",
                                                   "br": "Afeganistão",
                                                   "pt": "Afeganistão"],
                                    population: 27657145,
                                    countryCode: "AFG",
                                    region: "Asia",
                                    flagIconURL: URL(string:"http://www.geognos.com/api/en/countries/flag/AF.png"),
                                    capital: "Kabul",
                                    area: 652230,
                                    timeZones: ["UTC+04:30"],
                                    callingCodes: ["93"],
                                    currencies: ["Afghan afghani"],
                                    languages: ["Pashto", "Uzbek", "Turkmen"],
                                    nativeName: "افغانستان",
                                    borders: ["IRN", "PAK","TKM", "UZB", "TJK", "CHN"])


let countryListNames = ["Afghanistan", "Åland Islands", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba"]
}
