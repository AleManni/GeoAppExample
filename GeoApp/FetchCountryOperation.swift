//
//  FetchCountryOperation.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/08/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import LightOperations

final class FetchCountryOperation: LightOperation {

    override open func main() {
        super.main()
        NetworkManager.fetchCountryList(completion: { [weak self] result in
            switch result {
            case .success(let instantiatable):
                self?.operationFinalResult = .success(instantiatable)
                self?.operationCompletion(.success(instantiatable))
            case .failure(let error):
                self?.operationFinalResult = .failure(.networkError(error))
                self?.operationCompletion(.failure(.networkError(error)))
            }
            self?.state = .finished
        })
    }
}



