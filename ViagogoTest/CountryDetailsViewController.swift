//
//  CountryDetails.swift
//  ViagogoTest
//
//  Created by Alessandro Manni on 14/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class CountryDetailsViewController: UIViewController {
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var nativeNameLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    
   
    @IBOutlet weak var languagesTitle: UILabel!
    @IBOutlet weak var currencyTitle: UILabel!
    @IBOutlet weak var phoneTitle: UILabel!
    @IBOutlet weak var timeZoneTitle: UILabel!
    @IBOutlet weak var capitalTitle: UILabel!
    @IBOutlet weak var regionTitle: UILabel!
    @IBOutlet weak var regionDetailTitle: UILabel!
    
    @IBOutlet weak var regionCollectionView: UICollectionView!
    @IBOutlet weak var regionViewHeightConstr: NSLayoutConstraint!
    
    var country: CountryDetail?
    var region: Region?
    var regionViewIsShown: Bool = false {
        didSet {
            if regionViewIsShown == true {
                showRegionCollectionView()
            } else {
                hideRegionCollectionView()
            }
            }
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateView()
        formatText()
        regionCollectionView.delegate = self
        regionCollectionView.dataSource = self
        regionViewHeightConstr.constant = 0
        guard let reg = country!.region else {return}
        populateCVDataSource(reg)
    }
    
    func populateView() {
        guard let country = country else {return}
        if let countryNameLocalised = country.name!.localisedName(country.translations) {
            title = countryNameLocalised
        } else {title = country.name}
        if let nativeName = country.nativeName {
            nativeNameLabel.text = nativeName
        } else {
            nativeNameLabel.text = "\(Constants().stringMissing)"
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
            regionLabel.text = (Constants().stringMissing)
        }
        if let _ = country.flagIconURL {
            flagImageView.imageFromUrl(country.flagIconURL!)
        } else {
            flagImageView.image = UIImage(named: "placeholder")
        }
        if let _ = country.languages, let languagesValue = country.languages where languagesValue.count > 0 {
            languagesLabel.text = String().composeFromArray(country.languages!)
        } else {
            languagesLabel.text = (Constants().stringMissing)
        }
        if let _ = country.callingCodes, let codesValue = country.callingCodes where codesValue.count > 0 {
            phoneLabel.text = String().composeFromArray(country.callingCodes!)
        } else {
            phoneLabel.text = (Constants().stringMissing)
        }
        if let _ = country.capital, let valueCapital = country.capital?.characters.count where valueCapital > 0 {
            capitalLabel.text = (country.capital)
        } else {
            capitalLabel.text = (Constants().stringMissing)
        }
        if let _ = country.timeZones, let zonesValue = country.timeZones where zonesValue.count > 0 {
            timeZoneLabel.text = String().composeFromArray(country.timeZones!)
        } else {
            timeZoneLabel.text = (Constants().stringMissing)
        }
        if let _ = country.currencies, let currencyValue = country.currencies where currencyValue.count > 0 {
            currencyLabel.text = String().composeFromArray(country.currencies!)
        } else {
            currencyLabel.text = (Constants().stringMissing)
        }
        if let _ = country.region, let regionDetailValue = country.region where regionDetailValue.characters.count > 0 {
            regionDetailTitle.text = "\(country.region!.uppercaseString): countries"
        }
    
    }
    
    func formatText() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.Colors().standardBlue, NSFontAttributeName: Constants.Fonts().titleLarge]
        let labelsArray = [nativeNameLabel, populationLabel, languagesLabel, currencyLabel, phoneLabel, capitalLabel, timeZoneLabel, regionLabel]
        let titlesArray = [languagesTitle, currencyTitle, phoneTitle, timeZoneTitle, capitalTitle, regionTitle, regionDetailTitle]
        for item in labelsArray {
            item.font = Constants.Fonts().regular
        }
        for item in titlesArray {
            item.font = Constants.Fonts().small
        }
    }
    
    func populateCVDataSource(regionName: String) {
            ConnectionManager.fetchRegion(regionName, callback: { (callback) in
                guard callback.error == nil else {
                    ErrorHandler.handler.showError(callback.error!, sender: self)
                    return
                }
                self.region = callback.response! as Region
                self.regionCollectionView.reloadData()
            })
        }
    
    //MARK: - Actions
    
    @IBAction func didTapRegionView(sender: AnyObject) {
       regionViewIsShown = !regionViewIsShown
    }




//MARK - Animations

func showRegionCollectionView() {
    //regionCollectionView.reloadData()
    UIView.animateWithDuration(0.25, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 20, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () in
        self.regionViewHeightConstr.constant = 108
        self.view.layoutIfNeeded() },
                               completion: {(finished: Bool) in
                                self.view.layoutIfNeeded()
    })
    }
    
    func hideRegionCollectionView() {
        UIView.animateWithDuration(0.25, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 20, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () in
            self.regionViewHeightConstr.constant = 0
            self.view.layoutIfNeeded() },
                                   completion: {(finished: Bool) in
                                    self.view.layoutIfNeeded()
        })
    }
}

extension CountryDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let _ = region else {return 0}
        return (region?.countryList!.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("detailCollectionCell", forIndexPath: indexPath) as! DetailCollectionCell
        
        cell.populateWithCountry((region?.countryList![indexPath.row])!)
        cell.drawLayout()
        return cell
    }
}
