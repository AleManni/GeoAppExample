//
//  Protocols.swift
//  GeoApp
//
//  Created by Alessandro Manni on 02/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

public enum DataConstructorResult {
    case success(InstantiatableFromResponse)
    case failure(Errors)
}

public protocol InstantiatableFromResponse: class {
    init?(_ response: AnyObject)
}

protocol DataConstructor: class {
    func instantiateFromResponse(_ response: Data, callback: (DataConstructorResult) -> Void)
    init(_ objectClass: InstantiatableFromResponse.Type)
}

protocol ViewModelDelegate: class {
    func viewModelIsLoading(viewModel: ViewModel)
    func viewModelDidLoadData<T>(data: T, viewModel: ViewModel)
    func viewModelDidFailWithError(error: Errors, viewModel: ViewModel)
}

protocol ViewModel: class {
    init<T: InstantiatableFromResponse>(_ data: T)
}


