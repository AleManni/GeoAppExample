//
//  ErrorVC.swift
//  Ostmodern_CodeTest
//
//  Created by Alessandro Manni - on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

protocol ErrorViewDelegate: class {
    func viewIsShown(_ isShown:Bool)
    func viewDidCancel()
}


import UIKit

class ErrorView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTextLabel: UILabel!
    weak var delegate:ErrorViewDelegate?
    
    override func awakeFromNib() {
        StyleManager.shared.formatLabels([titleLabel])
        StyleManager.shared.formatLabels([subTextLabel])
    }
    
    @IBAction func didPressCloseButton(_ sender: AnyObject) {
        removeSelf()
        delegate?.viewDidCancel()
    }
    
    func removeSelf() {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.alpha = 0
        }, completion: { (finished) -> Void in
            if(finished) {
                self.delegate?.viewIsShown(false)
                self.removeFromSuperview()
            }
        }) 
    }
}
