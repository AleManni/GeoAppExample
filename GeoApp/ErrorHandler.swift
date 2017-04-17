//
//  ErrorHandler.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//


enum Errors: Error {
    case noData
    case jsonError
    case networkError(error: NSError)
    
    var description: (title: String, message: String) {
        switch self {
        case .noData:
            return ("Error", "No valid data returned from server")
        case .jsonError:
            return ("Error", "Response from server cannot be converted in readable data")
        case .networkError(let error):
            return ("Error \(error.code)", error.localizedDescription)
        }
    }
}


import Foundation
import UIKit

class ErrorHandler: NSObject, ErrorViewDelegate {
    
    static var handler = ErrorHandler()
    var alert:ErrorView?
    var alertIsShown = false
    var constraintWidth: NSLayoutConstraint?
    var constraintHeight: NSLayoutConstraint?
    var constraintX: NSLayoutConstraint?
    var constraintY: NSLayoutConstraint?
    
    func showError(_ error: Errors, sender: UIViewController) {
        guard alertIsShown == false else {return}
        alert = Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)?[0] as? ErrorView
        alert?.delegate = self
        alert?.frame = CGRect.zero
        viewIsShown(true)
        alert!.titleLabel.text = error.description.title
        alert!.subTextLabel.text = error.description.message
        alert!.titleLabel.textColor = Colors.standardBlue
        alert!.subTextLabel.textColor = Colors.standardBlue
        alert!.center = sender.view.center
        sender.view.addSubview(alert!)
        sender.view.bringSubview(toFront: alert!)
        layoutAlertView(alert!, sender: sender)
    }
    
    
    private func layoutAlertView(_ alert:UIView, sender:UIViewController) {
        alert.translatesAutoresizingMaskIntoConstraints = false
        constraintX = NSLayoutConstraint(item: alert, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: sender.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
        constraintY = NSLayoutConstraint(item: alert, attribute: .centerYWithinMargins, relatedBy: .equal, toItem: sender.view, attribute: .centerYWithinMargins, multiplier: 1, constant: 0)
        constraintWidth = NSLayoutConstraint(item: alert, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 200)
        constraintHeight = NSLayoutConstraint(item: alert, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 150)
        UIView.animate(withDuration: 0.2, animations: {
            sender.view.addConstraints([self.constraintX!, self.constraintY!, self.constraintWidth!, self.constraintHeight!])
            alert.layoutIfNeeded()
            }, completion: { (true) in
                self.setShadow()
        })
    }
    
    private func setShadow() {
        alert!.layer.shadowColor = UIColor.gray.cgColor
        alert!.layer.shadowOpacity = 1
        alert!.layer.shadowOffset = CGSize.zero
        alert!.layer.shadowRadius = 10
    }
    
    func viewIsShown(_ isShown:Bool) {
        alertIsShown = isShown
    }
}
