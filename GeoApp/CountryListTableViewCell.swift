//
//  CountryListTableViewCell.swift
//  GeoApp
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
        return UINib(nibName: "CountryListTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CountryListTableViewCell
    }
    
    
    func populateWith(_ country: CountryDetail) {
        if let name = country.name {
            if let countryNameLocalised = name.localisedName(country.translations) {
                countryNameLabel.text = countryNameLocalised
            } else {countryNameLabel.text = name}
        }
        
        if let population = country.population, let value = country.population, value != 0 {
            let populationByMillions = Double(population)/1000000
            populationLabel.text = "Population: \(populationByMillions)M"
        } else {
            populationLabel.text = "Population: \(Constants().stringMissing)"
        }
        if let region = country.region, let regionValue = country.region, regionValue.characters.count > 0 {
            regionLabel.text = (region)
        } else {
            regionLabel.text = "Region: \(Constants().stringMissing)"
        }
        
        if let flagURL = country.flagIconURL {
            flagImageView.imageFromUrl(flagURL)
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

