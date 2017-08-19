//
//  FetchCountryOperation.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/08/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//


final class FetchCountryOperation : GAOperation {

    override open func main() {
        super.main()
        NetworkManager.fetchCountryList(completion: { result in
            switch result {
            case .success(let instantiatable):
                self.operationFinalResult = .success(instantiatable)
                self.operationCompletion(.success(instantiatable))
            case .failure(let error):
                self.operationFinalResult = .failure(error)
                self.operationCompletion(.failure(error))
            }
            self.state = .Finished
        })
    }
}



