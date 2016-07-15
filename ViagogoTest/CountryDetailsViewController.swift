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
    @IBOutlet weak var borderLabel: UILabel!
    
    @IBOutlet weak var languagesTitle: UILabel!
    @IBOutlet weak var currencyTitle: UILabel!
    @IBOutlet weak var phoneTitle: UILabel!
    @IBOutlet weak var timeZoneTitle: UILabel!
    @IBOutlet weak var capitalTitle: UILabel!
    @IBOutlet weak var regionTitle: UILabel!
    @IBOutlet weak var borderTitle: UILabel!
    @IBOutlet weak var regionDetailTitle: UILabel!
    
    @IBOutlet weak var regionView: UIView!
    @IBOutlet weak var regionIconView: UIImageView!
    @IBOutlet weak var regionArrowView: UIImageView!
    @IBOutlet weak var bordersView: UIView!
    @IBOutlet weak var borderIconView: UIImageView!
    @IBOutlet weak var borderArrowView: UIImageView!
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet weak var regionCollectionView: UICollectionView!
    @IBOutlet weak var regionViewHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var neighbouringCountriesTableView: UITableView!
    @IBOutlet weak var neighbouringTVHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var scroll: UIScrollView!
    
    var country: CountryDetail?
    var region: Region?
    var neighbouringCountries: [CountryDetail] = []
    
    var regionViewIsShown: Bool = false {
        didSet {
            if regionViewIsShown {
                tableViewIsShown = !regionViewIsShown
                showRegionCollectionView()
            } else {
                hideRegionCollectionView()
            }
        }
    }
    var tableViewIsShown: Bool = false {
        didSet {
            if tableViewIsShown {
                regionViewIsShown = !tableViewIsShown
                showTableView()
            } else {
                hideTableView()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = country?.region, let _ = country?.borders else {return}
        regionCollectionView.delegate = self
        regionCollectionView.dataSource = self
        neighbouringCountriesTableView.delegate = self
        neighbouringCountriesTableView.dataSource = self
        neighbouringCountriesTableView.registerNib(UINib(nibName: "CountryListTableViewCell", bundle: nil), forCellReuseIdentifier: "countryCell")
        setupView()
    }
    
    func setupView() {
        populateView()
        formatText()
        populateCVDataSource(country!.region!)
        populateTableViewDataSource((country!.borders)!)
        neighbouringTVHeightConstr.constant = 0
        regionViewHeightConstr.constant = 0
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
            languagesLabel.text = String().composeFromArray(country.languages!).uppercaseString
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
        let labelsArray = [nativeNameLabel, populationLabel, languagesLabel, currencyLabel, phoneLabel, capitalLabel, timeZoneLabel, regionLabel, borderLabel]
        let titlesArray = [languagesTitle, currencyTitle, phoneTitle, timeZoneTitle, capitalTitle, regionTitle, borderTitle, regionDetailTitle, borderTitle]
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
            dispatch_async(dispatch_get_main_queue()) {
                self.region = callback.response! as Region
                self.regionCollectionView.reloadData()
            }
        })
    }
    
    func populateTableViewDataSource(countryCodes: [String]) {
        guard let borders = country!.borders else {return}
        var listOfCountries: [CountryDetail] = []
        for code in borders {
            ConnectionManager.fetchCountryDetails(code, callback: {(callback) in
                guard callback.error == nil else {
                    ErrorHandler.handler.showError(callback.error!, sender: self)
                    return
                }
                let newContry = callback.response as CountryDetail!
                listOfCountries.append(newContry)
                dispatch_async(dispatch_get_main_queue(), {
                    self.neighbouringCountries = listOfCountries
                    self.neighbouringCountriesTableView.reloadData()
                })
            })
        }
    }
    
    //MARK: - Actions
    
    @IBAction func didTapRegionView(sender: AnyObject) {
        regionViewIsShown = !regionViewIsShown
    }
    
    @IBAction func didTapBordersView(sender: AnyObject) {
        tableViewIsShown = !tableViewIsShown
    }
    
    //MARK: - Animations
    
    func showRegionCollectionView() {
        regionView.backgroundColor = Constants.Colors().standardBlue
        regionArrowView.setActive()
        regionIconView.setActive()
        regionTitle.textColor = UIColor.whiteColor()
        regionLabel.textColor = UIColor.whiteColor()
        
        UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 50, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () in
            self.regionViewHeightConstr.constant = 135
            self.separator.hidden = false
            self.view.layoutIfNeeded() },
                                   completion: {(finished: Bool) in
        })
    }
    
    func hideRegionCollectionView() {
        regionView.backgroundColor = UIColor.clearColor()
        regionTitle.textColor = UIColor.blackColor()
        regionLabel.textColor = UIColor.blackColor()
        regionIconView.setInactive()
        regionArrowView.setInactive()
        
        UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 50, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () in
            self.regionViewHeightConstr.constant = 0
            self.separator.hidden = true
            self.view.layoutIfNeeded() },
                                   completion: {(finished: Bool) in
        })
    }
    
    
    func showTableView() {
        bordersView.backgroundColor = Constants.Colors().standardBlue
        borderIconView.setActive()
        borderArrowView.setActive()
        borderTitle.textColor = UIColor.whiteColor()
        borderLabel.textColor = UIColor.whiteColor()
        self.neighbouringTVHeightConstr.constant = self.neighbouringCountriesTableView.contentSize.height
        self.neighbouringCountriesTableView.layoutIfNeeded()
    }
    
    func hideTableView() {
        bordersView.backgroundColor = UIColor.clearColor()
        borderIconView.setInactive()
        borderArrowView.setInactive()
        borderTitle.textColor = UIColor.blackColor()
        borderLabel.textColor = UIColor.blackColor()
        
        UIView.animateWithDuration(0.25, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 20, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () in
            self.neighbouringTVHeightConstr.constant = 0
            self.neighbouringCountriesTableView.layoutIfNeeded() },
                                   completion: {(finished: Bool) in
                                    self.scroll.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)        })
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

extension CountryDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard neighbouringCountries.count > 0 else {return 0}
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.numberOfRowsInSection(section) > 0 {
            return tableView.dequeueReusableCellWithIdentifier("sectionHeader")
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return neighbouringCountries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("countryCell") as! CountryListTableViewCell
        cell.populateWith(neighbouringCountries[indexPath.row])
        cell.formatCell()
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        country = neighbouringCountries[indexPath.row]
        tableViewIsShown = false
        scroll.scrollRectToVisible(CGRectMake(scroll.bounds.origin.x, scroll.bounds.origin.y, scroll.bounds.size.width, scroll.bounds.size.height), animated: true)
        setupView()
        view.layoutIfNeeded()
    }
}
