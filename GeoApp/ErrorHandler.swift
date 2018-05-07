//
//  ErrorHandler.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import Foundation
import LightOperations
import UIKit

public enum Errors: Error {
  case noData
  case jsonError(Error?)
  case networkError(error: NSError)
  case invalidURL
  case operationError(OperationError)
}

extension Errors: CustomStringConvertible {

    public var description: String {
        switch self {
        case .noData:
            return "No valid data returned from server"
        case .jsonError:
            return "Response from server cannot be converted in readable data"
        case .networkError(let error):
            return (error.localizedDescription)
        case .invalidURL:
            return "The provided url is not valid"
        case .operationError(let error):
            return (error.localizedDescription)
        }
    }
}

protocol ErrorHandlerDelegate: class {
    func alertDidCancel()
}

class ErrorHandler {
    
    static var handler = ErrorHandler()
    weak var delegate: ErrorHandlerDelegate?

    func showError(_ error: Errors, sender: UIViewController, delegate: ErrorHandlerDelegate, buttonTitle: String) {
        self.delegate = delegate
        let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: { tapped in
            delegate.alertDidCancel()
        }))
        sender.present(alert, animated: true, completion: nil)
    }
}
