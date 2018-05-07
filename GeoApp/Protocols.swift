//
//  Protocols.swift
//  GeoApp
//
//  Created by Alessandro Manni on 02/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

public enum DataConstructorResult {
    case success(Decodable)
    case failure(Error)
}

public enum OperationResult<T> {
  case success(T)
  case failure(Error?)

  var type: T.Type {
    return T.self
  }
}

protocol DataConstructor {
  associatedtype NetworkType: Decodable
}

extension DataConstructor {

  func instantiateFromResponse(_ response: Data, completion: (DataConstructorResult) -> Void)  {
    do {
      let decoder = JSONDecoder()
      let networkModel = try decoder.decode(NetworkType.self, from: response)
      completion(.success(networkModel))
    } catch let parsingError {
      completion(.failure(parsingError))
      return
    }
  }
}

public protocol ViewModelDelegate: class {
    func viewModelIsLoading(viewModel: ViewModel)
    func viewModelDidLoadData<T>(data: T, viewModel: ViewModel)
    func viewModelDidFailWithError(error: Errors, viewModel: ViewModel)
}

public protocol ViewModel: class {
  weak var delegate: ViewModelDelegate? { get set }

  func loadData()
  func repositoryDidFetchResult<T>(_ result: OperationResult<T>)
}


