//
//  ErrorHandler.swift
//  ViagogoTest
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

//
//  ErrorHandler.swift
//  Ostmodern_CodeTest
//
//  Created by Alessandro Manni - on 21/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//


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
        sender.view.addSubview(alert!)
        sender.view.bringSubviewToFront(alert!)
        setUpAlertView(alert!, sender: sender)
    }
    
    
    func setUpAlertView (alert:UIView, sender:UIViewController) {
        
        alert.frame = CGRectMake(1,1,1,1)
        alert.center = sender.view.convertPoint(sender.view.center,
                                                fromView:sender.view.superview)
        
        let portraitX = sender.view.frame.size.width/8
        let portraitY = sender.view.frame.size.height/3
        let landscapeX = sender.view.frame.size.width/4
        let landscapeY = sender.view.frame.size.height/4
        
        let originalFrame = CGRectMake(portraitX, portraitY, 10, 10)
        alert.frame = originalFrame
        let newFramePortrait = CGRectMake(portraitX, portraitY, (sender.view.frame.size.width/8)*6, sender.view.frame.size.height/4)
        let newFrameLandscape = CGRectMake(landscapeX, landscapeY, (sender.view.frame.size.width/2), sender.view.frame.size.height/2.5)
        
        UIView.animateWithDuration(0.5, animations: {
            if UIDevice.currentDevice().orientation == .Portrait {
                alert.frame = newFramePortrait} else {
                alert.frame = newFrameLandscape}
            alert.layoutIfNeeded()
        })
    }
    func viewIsShown(isShown:Bool) {
        alertIsShown = isShown
    }
}
