//
//  PrintCountryListOperation.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/08/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

final class PrintCountryListOperation : GAOperation {

    override open func main() {
        super.main()
        if let data = self.initialData as? [String] {
            print(data)
            self.operationFinalResult = .success(data)
            self.operationCompletion(.success(data))
            self.state = .Finished
        } else {
            if let data = self.initialData {
                self.operationFinalResult = .failure(.operationError(.unexpectedInputDataType(data)))
            } else {
                self.operationFinalResult = .failure(.operationError(.initialDataMissing))
            }
            self.state = .Cancelled
        }
        self.state = .Finished
    }
}




