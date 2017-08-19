//
//  GAOperation.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/08/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

public enum OperationState: String {
    case Ready, Executing, Finished

    fileprivate var keyPath: String {
        return "is" + self.rawValue
    }
}

public enum GAOperationFinalResult<T> {
    case success(T)
    case error(Errors)
}

open class GAOperation : Operation {


    open var operationFinalResult: GAOperationFinalResult<Any>?
    open var initialData: GAOperationFinalResult<Any>?

    override open var isAsynchronous: Bool {
        return true
    }

    var state = OperationState.Ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }

    override open var isExecuting: Bool {
        return state == .Executing
    }

    override open var isFinished: Bool {
        return state == .Finished
    }

    var operationCompletion: ((GAOperationFinalResult<Any>) -> Void)

    init(operationCompletion: @escaping ((GAOperationFinalResult<Any>) -> Void)) {
        self.operationCompletion = operationCompletion
        super.init()
        self.name = String(describing: self)
    }

    override open func start() {
        if self.isCancelled {
            state = .Finished
        } else {
            state = .Ready
            main()
        }
    }

    override open func main() {
        if self.isCancelled {
            state = .Finished
            return
        } else {
            state = .Executing
            print("Executing \(self.name ?? "un-named operation")")
        }
    }
}


