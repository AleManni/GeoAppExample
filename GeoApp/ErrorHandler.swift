//
//  ErrorHandler.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//


public enum Errors: Error {
    case noData
    case jsonError
    case networkError(error: NSError)
    case invalidURL
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
        }
    }
}

protocol ErrorHandlerDelegate: class {
    func viewDidCancel()
}


import Foundation
import UIKit

class ErrorHandler: NSObject {
    
    static var handler = ErrorHandler()
    var alert:ErrorView?
    var alertIsShown = false
    var constraintWidth: NSLayoutConstraint?
    var constraintHeight: NSLayoutConstraint?
    var constraintX: NSLayoutConstraint?
    var constraintY: NSLayoutConstraint?

    weak var delegate: ErrorHandlerDelegate?

    fileprivate func layoutAlertView(_ alert: UIView, sender: UIViewController) {
        alert.alpha = 0
        alert.translatesAutoresizingMaskIntoConstraints = false
        constraintX = NSLayoutConstraint(item: alert, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: sender.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
        constraintY = NSLayoutConstraint(item: alert, attribute: .centerYWithinMargins, relatedBy: .equal, toItem: sender.view, attribute: .centerYWithinMargins, multiplier: 1, constant: 0)
        constraintWidth = NSLayoutConstraint(item: alert, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 0)
        constraintHeight = NSLayoutConstraint(item: alert, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 150)
        sender.view.addConstraints([self.constraintX!, self.constraintY!, self.constraintWidth!, self.constraintHeight!])

        UIView.animate(withDuration: 0.2, animations: {
            alert.alpha = 1
            self.constraintWidth?.constant = 200
            alert.layoutIfNeeded()
            }, completion: nil
        )
    }
    
    func viewIsShown(_ isShown:Bool) {
        alertIsShown = isShown
    }
}

extension ErrorHandler: ErrorViewDelegate {

    func showError(_ error: Errors, sender: UIViewController, delegate: ErrorHandlerDelegate, buttonTitle: String) {
        guard alertIsShown == false else {
            return
        }
        self.delegate = delegate
        alert = Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)?[0] as? ErrorView
        alert?.delegate = self
        alert?.button.setTitle(buttonTitle, for: .normal)
        viewIsShown(true)
        alert!.titleLabel.text = "Error"
        alert!.subTextLabel.text = error.description
        sender.view.addSubview(alert!)
        alert!.center = sender.view.center
        layoutAlertView(alert!, sender: sender)
        sender.view.bringSubview(toFront: alert!)
    }

    func viewDidCancel() {
        delegate?.viewDidCancel()
        alertIsShown = false 
    }
}
