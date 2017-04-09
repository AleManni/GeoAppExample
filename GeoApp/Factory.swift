//
//  Factory.swift
//  GeoApp
//
//  Created by Alessandro Manni on 02/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

class Factory: DataConstructor {
    private var objectType: InstantiatableFromResponse.Type

    required init(_ objectClass: InstantiatableFromResponse.Type) {
        self.objectType = objectClass
    }

    func instantiateFromResponse(_ response: Data, callback: (InstantiatableFromResponse?, Errors?) -> Void)  {
        do {
            let swiftCollection = try JSONSerialization.jsonObject(with: response, options: JSONSerialization.ReadingOptions.mutableContainers)
            if let object = objectType.init(swiftCollection as AnyObject) {
                callback(object, nil)
            } else {
                callback(nil, Errors.jsonError)
            }
        } catch  {
            callback(nil, Errors.jsonError)
            return
        }
    }
}
