//
//  ErrorVC.swift
//  Ostmodern_CodeTest
//
//  Created by Alessandro Manni - on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

protocol ErrorViewDelegate: class {
    func viewIsShown(_ isShown:Bool)
}


import UIKit

class ErrorView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTextLabel: UILabel!
    weak var delegate:ErrorViewDelegate?
    
    override func awakeFromNib() {
        titleLabel.font = StyleManager.Fonts().title
        subTextLabel.font = StyleManager.Fonts().regular
    }
    
    @IBAction func didPressCloseButton(_ sender: AnyObject) {
        removeSelf()
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
