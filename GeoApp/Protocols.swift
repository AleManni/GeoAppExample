//
//  Protocols.swift
//  GeoApp
//
//  Created by Alessandro Manni on 02/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

protocol InstantiatableFromResponse: class {
    init?(_ response: AnyObject)
}

protocol DataConstructor: class {
    func instantiateFromResponse(_ response: Data, callback: (InstantiatableFromResponse?, Errors?) -> Void)
    init(_ objectClass: InstantiatableFromResponse.Type)
}

protocol viewModelDelegate: class {
    func viewModelIsLoading()
    func viewModelDidLoadData<T>(data: T)
    func viewModelDidFailWithError(error: Errors)
}


