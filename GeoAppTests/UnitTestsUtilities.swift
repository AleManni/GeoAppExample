//
//  UnitTestsUtilities.swift
//  GeoApp
//
//  Created by Alessandro Manni on 24/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

// Note: MockDataFactory and MockFiles will provide json data or a local url in order to test Factory and NetwworkManager classes

enum Mockfiles: String {
    case countryList
    case countryListCorrupted

}

class MockDataFactory {

    private static func url(for mockfile: Mockfiles) -> URL? {
        let bundle = Bundle(for: self)
        guard let path = bundle.path(forResource:  mockfile.rawValue, ofType: "json") else {
            return nil
        }
        return URL(fileURLWithPath: path)
    }

    static func data(from mockfile: Mockfiles) -> Data? {
        guard let url = url(for: mockfile) else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}

// MARK: - Other utils functions

func randomString(withLength length: Int) -> String {

    let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)

    var randomString = ""

    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
}



