//
//  DictionaryExtension.swift
//  GeoApp
//
//  Created by Alessandro Manni on 17/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

// Note: traverse multiple dictionaries in an array of dictionaries, extracting the values corresponding to the provided key
extension Sequence where Iterator.Element == [String: Any] {
    func values(of key: String) -> [Any] {
      return self.compactMap { $0[key] }
    }
}

