//
//  DetailCollectionCell.swift
//  GeoApp
//
//  Created by Alessandro Manni on 14/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class DetailCollectionCell: UICollectionViewCell {

    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!

    public func initiateWithData(_ data: CountryRegionRepresentable) {
        populateWith(data)
        formatCell()
    }


    private func populateWith(_ data: CountryRegionRepresentable) {
        countryCodeLabel.text = data.countryCode
        flagImageView.setImageFromURL(data.flagImageURL, placeHolder: #imageLiteral(resourceName: "placeholder"))
    }

    private func formatCell() {
        backgroundColor = Colors.standardBlue
        layer.masksToBounds = true
        layer.cornerRadius = 8.0
        StyleManager.shared.formatLabels([countryCodeLabel], color: .white)
    }
}
