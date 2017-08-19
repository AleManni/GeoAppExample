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
        if let data = self.initialData {
            switch data {
            case .success(let countryList):
                if let countryList = countryList as? CountryList,
                    let list = countryList.list.flatMap({ return $0.map { $0.name }}) {
                    self.operationFinalResult = .success(list)
                    self.operationCompletion(.success(list))
                }
            case .error(let error):
                self.operationFinalResult = .error(error)
            }
            self.state = .Finished
        }
    }
}




