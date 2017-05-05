//
//  DictionaryExtension.swift
//  GeoApp
//
//  Created by Alessandro Manni on 17/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element == [String: Any] {

    func values(of key: String) -> [Any] {
        return self.flatMap {$0[key]}
    }
}

