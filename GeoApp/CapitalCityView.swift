//
//  CapitalCityView.swift
//  GeoApp
//
//  Created by Alessandro Manni on 09/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation
import UIKit

protocol CapitalCityViewDelegate: class {
    func capitalViewDidSelectRegion(_ didSelect: Bool)
    func capitalViewDidSelectBorders(_ didSelect: Bool)
}

class CapitalCityView: UIView, UIGestureRecognizerDelegate {

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

    private var isRegionViewSelected: Bool = false {
        didSet {
            regionViewIsSelected(isRegionViewSelected)
            delegate?.capitalViewDidSelectRegion(isRegionViewSelected)
            if isRegionViewSelected, isBordersViewSelected {
                isBordersViewSelected = false
            }
        }
    }

    private var isBordersViewSelected: Bool = false {
        didSet {
            bordersViewIsSelected(isBordersViewSelected)
            delegate?.capitalViewDidSelectBorders(isBordersViewSelected)
            if isRegionViewSelected, isBordersViewSelected  {
                isRegionViewSelected = false
            }
        }
    }

    lazy private var tapRegion: UITapGestureRecognizer = {
        let tapRegion = UITapGestureRecognizer(target: self, action: #selector(didPerformSelection(_:)))
        tapRegion.delegate = self
        return tapRegion
    }()

    lazy private var tapBorders: UITapGestureRecognizer = {
        let tapBorders = UITapGestureRecognizer(target: self, action: #selector(didPerformSelection(_:)))
        tapBorders.delegate = self
        return tapBorders
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        regionView.addGestureRecognizer(tapRegion)
        bordersView.addGestureRecognizer(tapBorders)
    }

    weak var delegate: CapitalCityViewDelegate?

    func initiate(data: CapitalCityRepresentable?) {
        resetSelected()
        populate(data: data)
        formatText()
    }

    private func resetSelected() {
        isRegionViewSelected = false
        isBordersViewSelected = false
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

    @objc private func didPerformSelection(_ sender: UITapGestureRecognizer) {
        switch sender {
        case tapRegion:
            isRegionViewSelected = !isRegionViewSelected
            break
        case tapBorders:
            isBordersViewSelected = !isBordersViewSelected
        default:
            break
        }
    }

    // ACTIONS

    private func regionViewIsSelected(_ isSelected: Bool) {
        if isSelected {
            regionView.backgroundColor = Colors.standardBlue
            regionArrowView.setActive()
            regionIconView.setActive()
            regionTitle.textColor = .white
            regionLabel.textColor = .white
        } else {
            regionView.backgroundColor = .clear
            regionTitle.textColor = .black
            regionLabel.textColor = .black
            regionIconView.setInactive()
            regionArrowView.setInactive()
        }
    }

    private func bordersViewIsSelected(_ isSelected: Bool) {
        if isSelected {
            bordersView.backgroundColor = Colors.standardBlue
            borderIconView.setActive()
            borderArrowView.setActive()
            borderTitle.textColor = .white
            borderLabel.textColor = .white
        } else {
            bordersView.backgroundColor = .clear
            borderIconView.setInactive()
            borderArrowView.setInactive()
            borderTitle.textColor = .black
            borderLabel.textColor = .black
        }
    }
}
