//
//  CountryListTableViewCell.swift
//  ViagogoTest
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class CountryListTableViewCell: UITableViewCell {
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var regionImageView: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    
    
    static func newFromNib() -> CountryListTableViewCell {
        return UINib(nibName: "CountryListTableViewCell", bundle: nil).instantiateWithOwner(nil, options: nil).first as! CountryListTableViewCell
    }
    
    
    func populateWith(country: Country) {
        if let _ = country.name {
            if let countryNameLocalised = country.name!.localisedName(country.translations) {
                countryNameLabel.text = countryNameLocalised
            } else {countryNameLabel.text = country.name}
        }
        
        if let _ = country.population, let value = country.population where value != 0 {
            let populationByMillions = Double(country.population!)/1000000
            populationLabel.text = "Population: \(populationByMillions)M"
        } else {
            populationLabel.text = "Population: \(Constants().stringMissing)"
        }
        if let _ = country.region, let regionValue = country.region where regionValue.characters.count > 0 {
            regionLabel.text = (country.region!)
        } else {
            regionLabel.text = "Region: \(Constants().stringMissing)"
        }
        
        if let _ = country.flagIconURL {
            flagImageView.imageFromUrl(country.flagIconURL!)
        } else {
            flagImageView.image = UIImage(named: "placeholder")
        }
    }
    
    func formatCell() {
        countryNameLabel.font = Constants.Fonts().title
        populationLabel.font = Constants.Fonts().regular
        regionLabel.font = Constants.Fonts().regular
        countryNameLabel.textColor = Constants.Colors().standardBlue
        populationLabel.textColor = Constants.Colors().standardBlue
        regionLabel.textColor = Constants.Colors().standardBlue
    }
    
    override func setHighlighted(highlighted: Bool, animated:Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if (highlighted) {
            self.backgroundColor = (Constants.Colors().standardBlue)
        } else {
            self.backgroundColor = (UIColor.whiteColor())
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
    }
    
}

