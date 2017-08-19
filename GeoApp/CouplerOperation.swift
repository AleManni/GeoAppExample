//
//  CouplerOperation.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/08/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

typealias OperationTransformer = (Any) -> Any?

class CouplerOperation: Operation {
    private var finishedOperation: GAOperation
    private var startingOperation: GAOperation
    private var operationTransformer: OperationTransformer

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

    init(finishedOperation: GAOperation, startingOperation: GAOperation, transformer: OperationTransformer? = { input in
        return input}) {
        self.finishedOperation = finishedOperation
        self.startingOperation = startingOperation
        self.operationTransformer = transformer!
        super.init()
        self.name = String(describing: self)
        self.addDependency(finishedOperation)
        startingOperation.addDependency(self)
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
            guard let result = self.finishedOperation.operationFinalResult else {
                state = .Cancelled
                self.cancel()
                return
            }
            switch result {
            case .success(let data):
                if let inputData = self.operationTransformer(data) {
                    self.startingOperation.initialData = inputData
                     self.state = .Finished
                }
            default:
                state = .Cancelled
                self.cancel()
                return
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
            print("\(self.name ?? "un-named operation") finished")
        case OperationState.Cancelled.keyPath:
            print("\(self.name ?? "un-named operation") CANCELLED")
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
