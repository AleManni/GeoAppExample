//
//  CountryDetailsRootView.swift
//  GeoApp
//
//  Created by Alessandro Manni on 09/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation
import UIKit

final class CountryDetailsRootView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var countryDetailsView: CountryDetailsView!
    @IBOutlet weak var capitalCityView: CapitalCityView!
    @IBOutlet weak var regionDetailView: RegionCollectionView!
    @IBOutlet weak var neighbouringCountriesView: BorderingCountriesTableView!

    @IBOutlet weak var regionDetailViewHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var neighbouringCountriesViewHeightConstr: NSLayoutConstraint!

    weak var delegate: CountryListViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        regionDetailViewHeightConstr.constant = 0
        neighbouringCountriesViewHeightConstr.constant = 0
    }

    var countryDetailsData: CountryDetailsRepresentable? {
        didSet {
            countryDetailsView.initiate(data: countryDetailsData)
        }
    }

    var capitalCityData: CapitalCityRepresentable? {
        didSet {
            capitalCityView.initiate(data: capitalCityData)
            capitalCityView.delegate = self
        }
    }

    var countryRegionCollectionData: [CountryRegionRepresentable]? {
        didSet {
            regionDetailView.data = countryRegionCollectionData
        }
    }

    var borderingCountriesData: [CountryRepresentable]? {
        didSet {
            neighbouringCountriesView.data = borderingCountriesData
            neighbouringCountriesView.delegate = self
        }
    }

    fileprivate let topOffset = CGPoint(x: 0,  y: 0)
    fileprivate var bottomOffSet: CGPoint {
        return CGPoint(x: 0, y: countryDetailsView.bounds.size.height)
    }
}

extension CountryDetailsRootView: BorderingCountriesTableViewDelegate {

    func viewDidSelectCountry(countryName: String) {
        capitalViewDidSelectBorders(false)
        delegate?.viewDidSelectCountry(countryName: countryName)
    }
}

extension CountryDetailsRootView: CapitalCityViewDelegate {

    func capitalViewDidSelectRegion(_ didSelect: Bool) {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 4, initialSpringVelocity: 30, options: UIViewAnimationOptions(), animations: { () in
            self.regionDetailViewHeightConstr.constant = didSelect ? 135 : 0
            self.regionDetailView.separator.isHidden = !didSelect
            self.layoutIfNeeded() },
                       completion: {(finished: Bool) in
                        self.regionDetailView.collectionView.contentOffset = CGPoint.zero
        })
    }

    func capitalViewDidSelectBorders(_ didSelect: Bool) {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 4, initialSpringVelocity: 30, options: UIViewAnimationOptions(), animations: { () in
            self.neighbouringCountriesViewHeightConstr.constant = didSelect ? self.neighbouringCountriesView.intrinsicHeight : 0
            if didSelect {
                self.scrollView.setContentOffset(self.bottomOffSet, animated: true)
            }
            self.layoutIfNeeded() },
                       completion: {(finished: Bool) in
                        if !didSelect {
                            self.scrollView.setContentOffset(self.topOffset, animated: true)
                        }
        })
    }
}

