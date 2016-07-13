//
//  ErrorVC.swift
//  Ostmodern_CodeTest
//
//  Created by Alessandro Manni - on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

protocol ErrorViewDelegate: class {
    func viewIsShown(isShown:Bool)
}


import UIKit

class ErrorView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTextLabel: UILabel!
    weak var delegate:ErrorViewDelegate?
    
    override func awakeFromNib() {
        titleLabel.font = Constants.Fonts().title
        subTextLabel.font = Constants.Fonts().regular
    }
    
    @IBAction func didPressCloseButton(sender: AnyObject) {
        removeSelf()
    }
    
    func removeSelf() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.alpha = 0
        }) { (finished) -> Void in
            if(finished) {
                self.delegate?.viewIsShown(false)
                self.removeFromSuperview()
            }
        }
    }
    
    
}
