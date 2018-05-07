//
//  Factory.swift
//  GeoApp
//
//  Created by Alessandro Manni on 02/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

struct Factory<type: Decodable>: DataConstructor {
  typealias NetworkType = type
}
