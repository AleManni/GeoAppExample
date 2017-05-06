//
//  MockObjects.swift
//  GeoApp
//
//  Created by Alessandro Manni on 05/05/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import XCTest
@testable import GeoApp

class MockObjects {
    static let shared = MockObjects()

    let afghanistan = CountryDetail(name: "Afghanistan",
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

    let neverLand = CountryDetail(name: "NeverLand",
                                  translations: ["de": "NeverLanden",
                                                 "es": "NeverLandia",
                                                 "fr": "NeverLån",
                                                 "ja": "アフガニスタン",
                                                 "it": "NeverLandia",
                                                 "br": "NeverLandão",
                                                 "pt": "NeverLandão"],
                                  population: 1,
                                  countryCode: "NLD",
                                  region: "Blue sky",
                                  flagIconURL: URL(string:"http://www.geognos.com/api/en/countries/flag/NLD.png"),
                                  capital: "Neverland City",
                                  area: 20,
                                  timeZones: ["UTC+00:01"],
                                  callingCodes: ["999"],
                                  currencies: ["Apples"],
                                  languages: ["Neverlandian"],
                                  nativeName: "HocusPocus",
                                  borders: [])


    let countryListNames = ["Afghanistan", "Åland Islands", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba"]

    let countryListRawDictionary =
        [
            [
                "name": "Afghanistan",
                "topLevelDomain": [
                    ".af"
                ],
                "alpha2Code": "AF",
                "alpha3Code": "AFG",
                "callingCodes": [
                    "93"
                ],
                "capital": "Kabul",
                "altSpellings": [
                    "AF",
                    "Afġānistān"
                ],
                "region": "Asia",
                "subregion": "Southern Asia",
                "population": 27657145,
                "latlng": [
                    33,
                    65
                ],
                "demonym": "Afghan",
                "area": 652230,
                "gini": 27.8,
                "timezones": [
                    "UTC+04:30"
                ],
                "borders": [
                    "IRN",
                    "PAK",
                    "TKM",
                    "UZB",
                    "TJK",
                    "CHN"
                ],
                "nativeName": "افغانستان",
                "numericCode": "004",
                "currencies": [
                    [
                        "code": "AFN",
                        "name": "Afghan afghani",
                        "symbol": "؋"
                    ]
                ],
                "languages": [
                    [
                        "iso639_1": "ps",
                        "iso639_2": "pus",
                        "name": "Pashto",
                        "nativeName": "پښتو"
                    ],
                    [
                        "iso639_1": "uz",
                        "iso639_2": "uzb",
                        "name": "Uzbek",
                        "nativeName": "Oʻzbek"
                    ],
                    [
                        "iso639_1": "tk",
                        "iso639_2": "tuk",
                        "name": "Turkmen",
                        "nativeName": "Türkmen"
                    ]
                ],
                "translations": [
                    "de": "Afghanistan",
                    "es": "Afganistán",
                    "fr": "Afghanistan",
                    "ja": "アフガニスタン",
                    "it": "Afghanistan",
                    "br": "Afeganistão",
                    "pt": "Afeganistão"
                ],
                "flag": "https://restcountries.eu/data/afg.svg",
                "regionalBlocs": [
                    [
                        "acronym": "SAARC",
                        "name": "South Asian Association for Regional Cooperation",
                        "otherAcronyms": [],
                        "otherNames": []
                    ]
                ]
            ],
            [
                "name": "Armenia",
                "topLevelDomain": [
                    ".am"
                ],
                "alpha2Code": "AM",
                "alpha3Code": "ARM",
                "callingCodes": [
                    "374"
                ],
                "capital": "Yerevan",
                "altSpellings": [
                    "AM",
                    "Hayastan",
                    "Republic of Armenia",
                    "Հայաստանի Հանրապետություն"
                ],
                "region": "Asia",
                "subregion": "Western Asia",
                "population": 2994400,
                "latlng": [
                    40,
                    45
                ],
                "demonym": "Armenian",
                "area": 29743,
                "gini": 30.9,
                "timezones": [
                    "UTC+04:00"
                ],
                "borders": [
                    "AZE",
                    "GEO",
                    "IRN",
                    "TUR"
                ],
                "nativeName": "Հայաստան",
                "numericCode": "051",
                "currencies": [
                    [
                        "code": "AMD",
                        "name": "Armenian dram",
                        "symbol": nil
                    ]
                ],
                "languages": [
                    [
                        "iso639_1": "hy",
                        "iso639_2": "hye",
                        "name": "Armenian",
                        "nativeName": "Հայերեն"
                    ],
                    [
                        "iso639_1": "ru",
                        "iso639_2": "rus",
                        "name": "Russian",
                        "nativeName": "Русский"
                    ]
                ],
                "translations": [
                    "de": "Armenien",
                    "es": "Armenia",
                    "fr": "Arménie",
                    "ja": "アルメニア",
                    "it": "Armenia",
                    "br": "Armênia",
                    "pt": "Arménia"
                ],
                "flag": "https://restcountries.eu/data/arm.svg",
                "regionalBlocs": [
                    [
                        "acronym": "EEU",
                        "name": "Eurasian Economic Union",
                        "otherAcronyms": [
                            "EAEU"
                        ],
                        "otherNames": []
                    ]
                ]
            ]
            ]
            as [[String : Any]]

}

class mockViewModelDelegate: ViewModelDelegate {

    var loadedData: Any?
    var error: Errors?
    weak var expectation: XCTestExpectation?

    func viewModelDidLoadData<T>(data: T, viewModel: ViewModel) {
        loadedData = data
        expectation?.fulfill()
    }

    func viewModelDidFailWithError(error: Errors, viewModel: ViewModel) {
        self.error = error
    }

    func viewModelIsLoading(viewModel: ViewModel) {
    }
}


