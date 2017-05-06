//
//  CountryListTableViewCell.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

final class CountryListTableViewCell: UITableViewCell {
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var regionImageView: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!

    public func initiateWithData(_ data: CountryRepresentable) {
        populateWith(data)
        formatCell()
    }


    private func populateWith(_ data: CountryRepresentable) {
        countryNameLabel.text = data.name
        populationLabel.text = data.population
        regionLabel.text = data.region
        flagImageView.setImageFromURL(data.flagImageURL, placeHolder: #imageLiteral(resourceName: "placeholder"), completion: nil)
    }

    private func formatCell() {
        StyleManager.shared.formatLabels([populationLabel, countryNameLabel])
        StyleManager.shared.formatTitleLabels([regionLabel])
    }

    override func setHighlighted(_ highlighted: Bool, animated:Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if (highlighted) {
            self.backgroundColor = (Colors.standardBlue)
        } else {
            self.backgroundColor = (.white)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }

}

