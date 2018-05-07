//
//  CountryDetailNetworkModel.swift
//  GeoApp
//
//  Created by Alessandro Manni on 07/05/2018.
//  Copyright © 2018 Alessandro Manni. All rights reserved.
//

import Foundation

typealias CountryListNetworkModel = [CountryDetailNetworkModel]

struct CountryDetailNetworkModel: Codable {
  let name: String
  let topLevelDomain: [String]
  let alpha2Code, alpha3Code: String
  let callingCodes: [String]
  let capital: String
  let altSpellings: [String]
  let region: String
  let population: Int
  let latlng: [Double]
  let demonym: String
  let area: Int
  let gini: Double?
  let timezones, borders: [String]
  let nativeName, numericCode: String
  let currencies: [Currency]
  let languages: [Language]
  let translations: Translations
  let flag: String
}

struct Currency: Codable {
  let code, name: String
  let symbol: String?
}

struct Language: Codable {
  let iso6391, iso6392, name, nativeName: String

  enum CodingKeys: String, CodingKey {
    case iso6391 = "iso639_1"
    case iso6392 = "iso639_2"
    case name, nativeName
  }
}

struct Translations: Codable {
  let de, es, fr, ja: String
  let it, br, pt: String
}
