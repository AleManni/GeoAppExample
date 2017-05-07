//
//  CountryRegionCollectionView.swift
//  GeoApp
//
//  Created by Alessandro Manni on 09/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation
import UIKit

final class RegionCollectionView: UIView {
    @IBOutlet weak var regionDetailTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var separator: UIView!

    var data: [CountryRegionRepresentable]? {
        didSet {
            regionDetailTitle.text = data?[0].regionName
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        setUpAccessibilityIdentifiers()
        setUpView()
    }

    func setUpView() {
    StyleManager.shared.formatTitleLabels([regionDetailTitle])
    collectionView.dataSource = self
    }

    func setUpAccessibilityIdentifiers() {
        collectionView.accessibilityIdentifier = "regionCollectionView"
    }
}

extension RegionCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = data, section == 0 {
            return data.count
        }
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "regionCell", for: indexPath) as! DetailCollectionCell
        if let country = data?[indexPath.row] {
        cell.initiateWithData(country)
        }
        return cell
    }
}
