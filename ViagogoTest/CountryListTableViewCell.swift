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
    @IBOutlet weak var accessoryImage: UIImageView!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var regionImageView: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    

    static func newFromNib() -> CountryListTableViewCell {
        return UINib(nibName: "CountryListTableViewCell", bundle: nil).instantiateWithOwner(nil, options: nil).first as! CountryListTableViewCell
    }
    
    func populateWith(country: Country) {
        if let countryNameLocalised = country.name!.localisedName(country.translations) {
            countryNameLabel.text = countryNameLocalised
        } else {countryNameLabel.text = country.name}
        
        if let _ = country.population {
            populationLabel.text = "Population: \(country.population)"
        } else {
            populationLabel.text = Constants().stringMissing
        }
            if let _ = country.region {
                regionLabel.text = country.region
            } else {
                populationLabel.text = Constants().stringMissing
        }
        if let _ = country.flagIconURL {
            flagImageView.imageFromUrl(country.flagIconURL!)
        } else {
            flagImageView.image = UIImage(named: "placeholder")
        }
    }
}

