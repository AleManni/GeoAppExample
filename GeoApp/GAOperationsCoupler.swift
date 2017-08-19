//
//  GAOperationsCoupler.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/08/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

class GAOperationsCoupler {
    let finishedOperation: GAOperation
    let startingOperation: GAOperation

    init(finishedOperation: GAOperation, startingOperation: GAOperation) {
        self.finishedOperation = finishedOperation
        self.startingOperation = startingOperation
    }

    lazy var coupleOperation: BlockOperation = {
        return BlockOperation(block: {
            self.startingOperation.initialData = self.finishedOperation.operationFinalResult
        })
    }()
}
