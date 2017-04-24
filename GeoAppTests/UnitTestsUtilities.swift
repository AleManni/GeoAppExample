//
//  UnitTestsUtilities.swift
//  GeoApp
//
//  Created by Alessandro Manni on 24/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

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


