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

    func instantiateFromResponse(_ response: Data, callback: (DataConstructorResult) -> Void)  {
        do {
            let swiftCollection = try JSONSerialization.jsonObject(with: response, options: JSONSerialization.ReadingOptions.mutableContainers)
            print(swiftCollection)
            guard let object = try objectType.init(swiftCollection as AnyObject) else {
                callback(.failure(Errors.jsonError))
                return
            }
            callback(.success(object))
        } catch  {
            print(response)
            callback(.failure(Errors.jsonError))
            return
        }
    }
}
