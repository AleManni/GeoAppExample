//
//  CountryDetailsView.swift
//  GeoApp
//
//  Created by Alessandro Manni on 09/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation
import UIKit

final class CountryDetailsView: UIView {

    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var nativeNameLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    @IBOutlet weak var timeZoneLabel: UILabel!

    @IBOutlet weak var languagesTitle: UILabel!
    @IBOutlet weak var currencyTitle: UILabel!
    @IBOutlet weak var phoneTitle: UILabel!
    @IBOutlet weak var timeZoneTitle: UILabel!
    @IBOutlet weak var separator: UIView!

    func initiate(data: CountryDetailsRepresentable?) {
        populate(data: data)
        formatText()
    }

    private func populate(data: CountryDetailsRepresentable?) {
        guard let data = data else {
            return
        }
        if let url = data.flagImageURL {
            flagImageView.setImageFromURL(url, placeHolder: #imageLiteral(resourceName: "placeholder"))
        }
        nativeNameLabel.text = data.nativeName
        populationLabel.text = data.population
        languagesLabel.text = data.languages
        currencyLabel.text = data.currency
        phoneLabel.text = data.phoneLabel
        timeZoneLabel.text = data.timeZone
    }

    private func formatText() {
        let labelsArray = [nativeNameLabel, populationLabel, languagesLabel, currencyLabel, phoneLabel, timeZoneLabel]
        let titlesArray = [languagesTitle, currencyTitle, phoneTitle, timeZoneTitle]
        StyleManager.shared.formatLabels(labelsArray as! [UILabel])
        StyleManager.shared.formatTitleLabels(titlesArray as! [UILabel])
    }
}
