//
//  StoreDownloader.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/08/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation


class StoreDownloader {

    var downloadResult: Result?

    lazy var storeDownloadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "StoreDownloderQueue"
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .background
        return queue
    }()

    lazy var fetchAllCountriesOperationClosure: (GAOperationFinalResult<Any>) -> Void = {  result in
        switch result {
        case .success(let countryList):
            if let countryList = countryList as? CountryList {
                self.downloadResult = Result.success(countryList)
            }
        case .failure(let error):
            self.storeDownloadQueue.cancelAllOperations()
            self.downloadResult = Result.failure(error)
        }
    }

    lazy var printCountryListOperationResultClosure: (GAOperationFinalResult<Any>) -> Void = { result in
        switch result {
        case .failure(let error):
            print(error)
        default:
            return
        }
    }

    lazy var fetchAllCountriesOperation: FetchCountryOperation = {
        return FetchCountryOperation(operationCompletion: self.fetchAllCountriesOperationClosure)
    }()

    lazy var printAllCountriesOperation: PrintCountryListOperation = {
        return PrintCountryListOperation(operationCompletion: self.printCountryListOperationResultClosure)
    }()

    let couplerTransformer: OperationTransformer = { input in
        if let countryList = input as? CountryList,
            let list = countryList.list.flatMap({ return $0.map { $0.name }}) {
            return list
        }
        return nil
    }

    lazy var operationsCoupler: CouplerOperation = {
        return CouplerOperation(finishedOperation: self.fetchAllCountriesOperation, startingOperation: self.printAllCountriesOperation, transformer: self.couplerTransformer)
    }()

    func populateStore(completion: @escaping (Result) -> Void) {
        storeDownloadQueue.addOperations([fetchAllCountriesOperation, operationsCoupler, printAllCountriesOperation], waitUntilFinished: true)
        guard let downloadResult = self.downloadResult else {
            let error = Errors.noData
            completion(.failure(error))
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
