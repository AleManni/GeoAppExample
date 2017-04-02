//
//  Deserializer.swift
//  GeoApp
//
//  Created by Alessandro Manni on 02/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

enum ResponseType {
    case dictionary
    case array

    func classType() -> AnyObject.Type {
        switch self {
        case .dictionary:
            return [String: AnyObject].self as! AnyObject.Type
        case .array:
            return [[String: AnyObject]].self as! AnyObject.Type
            
        }
    }
}

class Deserializer {


    func deserialize(jsonData: Data, to: ResponseType) {




    do {
        let c = to.classType()
    guard let jasonArray = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? c else {
    callback(nil, Errors.jsonError)
    return
    }
    var region = Region()
    region.populateFromResponse(jasonArray)
    callback(region, nil)
    } catch  {
    callback(nil, Errors.jsonError)
    return
    }

}
