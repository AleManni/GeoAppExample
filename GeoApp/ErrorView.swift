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
    
    @IBOutlet weak var button: UIButton!
    
    weak var delegate:ErrorViewDelegate?
    
    override func awakeFromNib() {
        StyleManager.shared.formatLabels([titleLabel])
        StyleManager.shared.formatLabels([subTextLabel])
        layer.cornerRadius = 10

        layer.borderWidth = 3.0
        layer.borderColor = Colors.darkBlue.cgColor

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 4.0
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
