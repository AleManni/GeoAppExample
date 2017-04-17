//
//  CapitalCityView.swift
//  GeoApp
//
//  Created by Alessandro Manni on 09/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation
import UIKit

class CapitalCityView: UIView {

    @IBOutlet weak var capitalTitle: UILabel!
    @IBOutlet weak var regionTitle: UILabel!
    @IBOutlet weak var borderTitle: UILabel!

    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var borderLabel: UILabel!

    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var regionView: UIView!
    @IBOutlet weak var regionIconView: UIImageView!
    @IBOutlet weak var regionArrowView: UIImageView!
    @IBOutlet weak var bordersView: UIView!
    @IBOutlet weak var borderIconView: UIImageView!
    @IBOutlet weak var borderArrowView: UIImageView!


    func initiate(data: CapitalCityRepresentable?) {
        populate(data: data)
        formatText()
    }

    private func populate(data: CapitalCityRepresentable?) {
        guard let data = data else {
            return
        }
        capitalLabel.text = data.capital
        regionLabel.text = data.region
    }

    private func formatText() {
        let labelsArray = [capitalLabel, regionLabel, borderLabel]
        let titlesArray = [capitalTitle, regionTitle, borderTitle]
        StyleManager.shared.formatLabels(labelsArray as! [UILabel])
        StyleManager.shared.formatTitleLabels(titlesArray as! [UILabel])
    }
}
