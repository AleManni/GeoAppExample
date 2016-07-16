//
//  ErrorHandler.swift
//  ViagogoTest
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//


enum Errors: ErrorType {
    case noData
    case jsonError
    case networkError(nsError: NSError)
    
    var description: (title: String, message: String) {
        switch self {
        case .noData:
            return ("Error", "No valid data returned from server")
        case .jsonError:
            return ("Error", "Response from server cannot be converted in readable data")
        case .networkError(let nsError):
            return ("Error \(nsError.code)", nsError.localizedDescription)
        }
    }
}


import Foundation
import UIKit

class ErrorHandler: NSObject, ErrorViewDelegate {
    
    static var handler = ErrorHandler()
    var alert:ErrorView?
    var alertIsShown = false
    
    func showError(error: Errors, sender: UIViewController) {
        guard alertIsShown == false else {return}
        alert = NSBundle.mainBundle().loadNibNamed("ErrorView", owner: self, options: nil)[0] as? ErrorView
        alert?.delegate = self
        viewIsShown(true)
        alert!.titleLabel.text = error.description.title
        alert!.subTextLabel.text = error.description.message
        alert!.titleLabel.textColor = Constants.Colors().standardBlue
        alert!.subTextLabel.textColor = Constants.Colors().standardBlue
        sender.view.addSubview(alert!)
        sender.view.bringSubviewToFront(alert!)
        setUpAlertView(alert!, sender: sender)
    }
    
    
    func setUpAlertView (alert:UIView, sender:UIViewController) {
        
        alert.translatesAutoresizingMaskIntoConstraints = false
        let constrX = NSLayoutConstraint(item: alert, attribute: .CenterXWithinMargins, relatedBy: .Equal, toItem: sender.view, attribute: .CenterXWithinMargins, multiplier: 1, constant: 0)
        let constrY = NSLayoutConstraint(item: alert, attribute: .CenterYWithinMargins, relatedBy: .Equal, toItem: sender.view, attribute: .CenterYWithinMargins, multiplier: 1, constant: 0)
        let constrWidth = NSLayoutConstraint(item: alert, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: 10)
        let constrHeight = NSLayoutConstraint(item: alert, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: 10)
        sender.view.addConstraints([constrX, constrY, constrWidth, constrHeight])
        let newConstrWidth = NSLayoutConstraint(item: alert, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: 200)
        let newConstrHeight = NSLayoutConstraint(item: alert, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: 150)
        sender.view.removeConstraints([constrWidth, constrHeight])
        UIView.animateWithDuration(0.5, animations: {
            sender.view.addConstraints([newConstrWidth, newConstrHeight])
            self.setShadow()
            alert.layoutIfNeeded()
        })
    }
    
    func setShadow() {
        alert!.layer.shadowColor = UIColor.grayColor().CGColor
        alert!.layer.shadowOpacity = 1
        alert!.layer.shadowOffset = CGSizeZero
        alert!.layer.shadowRadius = 10
    }
    
    func viewIsShown(isShown:Bool) {
        alertIsShown = isShown
    }
}
