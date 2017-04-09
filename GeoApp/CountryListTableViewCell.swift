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


    static func newFromNib() -> CountryListTableViewCell {
        return UINib(nibName: "CountryListTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CountryListTableViewCell
    }

    public func initiateWithData(_ data: CountryRepresentable) {
        populateWith(data)
        formatCell()
    }


    private func populateWith(_ data: CountryRepresentable) {
        countryNameLabel.text = data.name
        populationLabel.text = data.population
        regionLabel.text = data.region
        flagImageView.setImageFromURL(data.flagImageURL, placeHolder: #imageLiteral(resourceName: "placeholder"))
    }

    private func formatCell() {
        countryNameLabel.font = Constants.Fonts().title
        populationLabel.font = Constants.Fonts().regular
        regionLabel.font = Constants.Fonts().regular
        countryNameLabel.textColor = Constants.Colors().standardBlue
        populationLabel.textColor = Constants.Colors().standardBlue
        regionLabel.textColor = Constants.Colors().standardBlue
    }

    override func setHighlighted(_ highlighted: Bool, animated:Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if (highlighted) {
            self.backgroundColor = (Constants.Colors().standardBlue)
        } else {
            self.backgroundColor = (UIColor.white)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }

}

