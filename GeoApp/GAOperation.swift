//
//  GAOperation.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/08/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

public enum GAOperationErrors: Error {
    case unexpectedInputDataType(Any)
    case initialDataMissing
}
import Foundation
//TODO: lower cases and modify the keypath var
public enum OperationState: String {
    case Ready, Executing, Cancelled, Finished

     var keyPath: String {
        return "is" + self.rawValue
    }
}

public enum GAOperationFinalResult<T> {
    case success(T)
    case failure(Errors)
}

open class GAOperation: Operation {

    open var operationFinalResult: GAOperationFinalResult<Any>?
    open var initialData: Any?
    
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

    override open var isCancelled: Bool {
        return state == .Cancelled
    }

    var operationCompletion: ((GAOperationFinalResult<Any>) -> Void)

    init(operationCompletion: @escaping ((GAOperationFinalResult<Any>) -> Void)) {
        self.operationCompletion = operationCompletion
        super.init()
        self.name = String(describing: self)
    }

    override open func start() {
        addObserver(self, forKeyPath: OperationState.Executing.keyPath, options: .new, context: nil)
        addObserver(self, forKeyPath: OperationState.Finished.keyPath, options: .new, context: nil)
        addObserver(self, forKeyPath: OperationState.Cancelled.keyPath, options: .new, context: nil)
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
        }
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            return
        }
        switch keyPath {
        case OperationState.Executing.keyPath:
            print("\(self.name ?? "un-named operation") is executing")
        case OperationState.Finished.keyPath:
            print("\(self.name ?? "un-named operation") finished with result: \(String(describing: self.operationFinalResult))")
        case OperationState.Cancelled.keyPath:
            print("\(self.name ?? "un-named operation") CANCELLED with result: \(String(describing: self.operationFinalResult))")
        default:
            return
        }
    }

    deinit {
        removeObserver(self, forKeyPath: OperationState.Executing.keyPath)
        removeObserver(self, forKeyPath: OperationState.Finished.keyPath)
        removeObserver(self, forKeyPath: OperationState.Cancelled.keyPath)
    }
}
