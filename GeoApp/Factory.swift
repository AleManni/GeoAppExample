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

    func instantiateFromResponse(_ response: Data, completion: (DataConstructorResult) -> Void)  {
        do {
            let swiftCollection = try JSONSerialization.jsonObject(with: response, options: JSONSerialization.ReadingOptions.mutableContainers)
            guard let object = try objectType.init(swiftCollection as AnyObject) else {
                completion(.failure(Errors.jsonError))
                return
            }
            completion(.success(object))
        } catch  {
            completion(.failure(Errors.jsonError))
            return
        }
    }
}
