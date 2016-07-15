//
//  DetailCollectionCell.swift
//  ViagogoTest
//
//  Created by Alessandro Manni on 14/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class DetailCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    func drawLayout() {
        self.backgroundColor = Constants.Colors().standardBlue
        let layer = self.layer
        layer.masksToBounds = true
        layer.cornerRadius = 8.0
        countryCodeLabel.font = Constants.Fonts().small
        countryCodeLabel.textColor = UIColor.whiteColor()
    }
    
    func populateWithCountry(country: Country) {
        if let _ = country.countryCode {
            countryCodeLabel.text = country.countryCode!.uppercaseString
        }
        if let _ = country.flagIconURL {
            flagImageView.imageFromUrl(country.flagIconURL!)
        }
    }
}