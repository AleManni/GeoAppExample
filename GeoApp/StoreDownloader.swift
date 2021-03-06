//
//  StoreDownloader.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/08/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation
import LightOperations


class StoreDownloader {

    var downloadResult: Result?

    lazy var storeDownloadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "StoreDownloderQueue"
        queue.qualityOfService = .background
        return queue
    }()

    lazy var fetchAllCountriesOperationClosure: (OperationFinalResult<Any>) -> Void = { [weak self ] result in
        switch result {
        case .success(let countryList):
            if let countryList = countryList as? CountryList {
                self?.downloadResult = Result.success(countryList)
            }
        case .failure(let error):
            self?.storeDownloadQueue.cancelAllOperations()
            self?.downloadResult = Result.failure(.operationError(.networkError(error)))
        }
    }

    lazy var printCountryListOperationResultClosure: (OperationFinalResult<Any>) -> Void = { result in
        switch result {
        case .failure(let error):
            print(error)
        default:
            return
        }
    }

    lazy var fetchAllCountriesOperation: FetchCountryOperation? = { [weak self] in
      guard let `self` = self else {
        return nil
      }
        return FetchCountryOperation(operationCompletion: self.fetchAllCountriesOperationClosure)
    }()

  lazy var printAllCountriesOperation: PrintCountryListOperation? = { [weak self] in
    guard let `self` = self else {
    return nil
    }
        return PrintCountryListOperation(operationCompletion: self.printCountryListOperationResultClosure)
    }()

    let couplerTransformer: OperationTransformer = { input in
        if let countryList = input as? CountryList,
            let list = countryList.list.flatMap({ return $0.map { $0.name }}) {
            return list
        }
        return nil
    }

    lazy var operationsCoupler: CouplerOperation? = { [weak self ] in
      guard let `self` = self,
      let countryFetch = self.fetchAllCountriesOperation,
      let printCountries = self.printAllCountriesOperation
      else {
        return nil
      }
        return CouplerOperation(finishedOperation: countryFetch, startingOperation: printCountries, transformer: self.couplerTransformer)
    }()

    func populateStore(completion: @escaping (Result) -> Void) {
      guard let coupler = operationsCoupler,
        let countryFetch = self.fetchAllCountriesOperation,
        let printCountries = self.printAllCountriesOperation else {
        return
      }
        storeDownloadQueue.addOperations([countryFetch, coupler, printCountries], waitUntilFinished: true)
        guard let downloadResult = self.downloadResult else {
            completion(.failure(.noData))
            return
        }
        switch downloadResult {
        case .success(let countryList):
            completion(.success(countryList))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
