//
//  CollectionsUtilities.swift
//  GeoApp
//
//  Created by Alessandro Manni on 05/05/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

// Note: check if two arrays hold the same elements regardless to their order

precedencegroup LeftAssociativePrecedence {
    associativity: left
}

infix operator ~ : LeftAssociativePrecedence

public func ~ <T: Hashable>(lhs: [T], rhs: [T]) -> Bool {
    return Set(lhs) == Set(rhs)
}


