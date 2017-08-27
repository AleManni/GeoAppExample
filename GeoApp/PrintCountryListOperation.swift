//
//  PrintCountryListOperation.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/08/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import LightOperations

final class PrintCountryListOperation : LightOperation {

    override open func main() {
        super.main()
        if let data = self.initialData as? [String] {
            print(data)
            self.operationFinalResult = .success(data)
            self.operationCompletion(.success(data))
            self.state = .finished
        } else {
            if let data = self.initialData {
                self.operationFinalResult = .failure(.unexpectedInputType(data))
            } else {
                self.operationFinalResult = .failure(.inputDataMissing)
            }
            self.state = .cancelled
        }
        self.state = .finished
    }
}




