//
//  CountryDetails.swift
//  GeoApp
//
//  Created by Alessandro Manni on 14/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit


class CountryDetailsViewController: UIViewController {

    var selectedCountry: CountryDetail?
    var countries: [CountryDetail]? {
        didSet {
            self.selectedCountry = countries?.first(where: { $0.isSelected })
        }
    }

    lazy var rootView: CountryDetailsRootView = {
        self.view as! CountryDetailsRootView
    }()

    lazy var countryDetailsViewModel: CountryDetailsViewModel? = {
        if let selectedCountry = self.selectedCountry {
            let viewModel = CountryDetailsViewModel(country: selectedCountry)
            viewModel.delegate = self
            return viewModel
        } else {
            return nil
        }
    }()

    lazy var capitalCityViewModel: CapitalCityViewModel? = {
        if let selectedCountry = self.selectedCountry {
            let viewModel = CapitalCityViewModel(country: selectedCountry)
            viewModel.delegate = self
            return viewModel
        } else {
            return nil
        }
    }()

    lazy var countryRegionViewModel: RegionCountriesCollectionViewModel? = {
        if let region = self.selectedCountry?.region {
            let viewModel = RegionCountriesCollectionViewModel(region: region)
            viewModel.delegate = self
            return viewModel
        } else {
            return nil
        }
    }()

    lazy var borderingCountriesViewModel: BorderingCountriesViewModel? = {
        if let selectedCountry = self.selectedCountry {
            let viewModel = BorderingCountriesViewModel(country: selectedCountry)
            viewModel?.delegate = self
            return viewModel
        } else {
            return nil
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Colors.standardBlue, NSFontAttributeName: StyleManager.Fonts().titleLarge]
        setTitle()
        countryDetailsViewModel?.loadData()
        capitalCityViewModel?.loadData()
        countryRegionViewModel?.loadData()
        borderingCountriesViewModel?.loadData()
    }

    private func setTitle() {
        if let countryNameLocalised = selectedCountry?.name!.localisedName(self.selectedCountry?.translations) {
            title = countryNameLocalised
        } else {
            title = selectedCountry?.name ?? ""
        }
    }
}

extension CountryDetailsViewController: ViewModelDelegate {
    func viewModelIsLoading(viewModel: ViewModel) {

    }

    func viewModelDidLoadData<T>(data: T, viewModel: ViewModel) {
        switch viewModel {
        case is CountryDetailsViewModel:
            rootView.countryDetailsData = data as? CountryDetailsRepresentable
        case is  CapitalCityViewModel:
            rootView.capitalCityData = data as? CapitalCityRepresentable
        case is RegionCountriesCollectionViewModel:
            rootView.countryRegionCollectionData = data as? [CountryRegionRepresentable]
        case is BorderingCountriesViewModel:
            rootView.borderingCountriesData = data as? CountryListRepresentable
        default:
            break
        }
    }

    func viewModelDidFailWithError(error: Errors, viewModel: ViewModel) {

    }
}

extension CountryDetailsViewController: CountryListViewDelegate {
    func viewDidRequestDataUpdate() {
    }

    func viewDidSelectCountry(countryName: String) {
        // delegate?.viewDidSelectCountry(countryName: countryName)
        // TODO: We need t adopt a differnet strategy.
        //Make a model that initiate with the whole COuntryList. Make a CountryDetail property isSelected
        // init this VC with the model (not the country)
        // extrapolate the selected country n a VC property. DidSet will replace the existing view models of the rootview
    }
}


// instantiate vieModel using country
/*
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
 neighbouringCountriesTableView.register(UINib(nibName: "CountryListTableViewCell", bundle: nil), forCellReuseIdentifier: "countryCell")
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
 nativeNameLabel.text = "\(StyleManager.shared.stringMissing)"
 }
 if let population = country.population, let value = country.population, value != 0 {
 let populationByMillions = Double(population)/1000000
 populationLabel.text = "Population: \(populationByMillions)M"
 } else {
 populationLabel.text = "Population: \(StyleManager.shared.stringMissing)"
 }
 if let region = country.region, let regionValue = country.region, regionValue.characters.count > 0 {
 regionLabel.text = region
 } else {
 regionLabel.text = (StyleManager.shared.stringMissing)
 }
 if let flagURL = country.flagIconURL {
 flagImageView.setImageFromURL(flagURL)
 } else {
 flagImageView.image = UIImage(named: "placeholder")
 }
 if let languages = country.languages, let languagesValue = country.languages, languagesValue.count > 0 {
 languagesLabel.text = String().composeFromArray(languages).uppercased()
 } else {
 languagesLabel.text = (StyleManager.shared.stringMissing)
 }
 if let callingCodes = country.callingCodes, let codesValue = country.callingCodes, codesValue.count > 0 {
 phoneLabel.text = String().composeFromArray(callingCodes)
 } else {
 phoneLabel.text = (StyleManager.shared.stringMissing)
 }
 if let capital = country.capital, let valueCapital = country.capital?.characters.count, valueCapital > 0 {
 capitalLabel.text = (capital)
 } else {
 capitalLabel.text = (StyleManager.shared.stringMissing)
 }
 if let timeZones = country.timeZones, let zonesValue = country.timeZones, zonesValue.count > 0 {
 timeZoneLabel.text = String().composeFromArray(timeZones)
 } else {
 timeZoneLabel.text = (StyleManager.shared.stringMissing)
 }
 if let currencies = country.currencies, let currencyValue = country.currencies, currencyValue.count > 0 {
 currencyLabel.text = String().composeFromArray(currencies)
 } else {
 currencyLabel.text = (StyleManager.shared.stringMissing)
 }
 if let region = country.region, let regionDetailValue = country.region, regionDetailValue.characters.count > 0 {
 regionDetailTitle.text = "\(region.uppercased()): countries"
 }

 }

 func formatText() {
 self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: StyleManager.Colors().standardBlue, NSFontAttributeName: StyleManager.Fonts().titleLarge]
 let labelsArray = [nativeNameLabel, populationLabel, languagesLabel, currencyLabel, phoneLabel, capitalLabel, timeZoneLabel, regionLabel, borderLabel]
 let titlesArray = [languagesTitle, currencyTitle, phoneTitle, timeZoneTitle, capitalTitle, regionTitle, borderTitle, regionDetailTitle, borderTitle]
 for item in labelsArray {
 item?.font = StyleManager.Fonts().regular
 }
 for item in titlesArray {
 item?.font = StyleManager.Fonts().small
 }
 }
 }

 func populateCVDataSource(_ regionName: String) {
 ConnectionManager.fetchRegion(regionName, callback: { (result, error) in
 if let error = error {
 DispatchQueue.main.async(execute: {
 ErrorHandler.handler.showError(error, sender: self)
 })
 return
 }
 DispatchQueue.main.async {
 if let region = result {
 self.region = region
 self.regionCollectionView.reloadData()
 }
 }
 })
 }

 func populateTableViewDataSource(_ countryCodes: [String]) {
 guard let borders = country!.borders else {return}
 var listOfCountries: [CountryDetail] = []
 for code in borders {
 ConnectionManager.fetchCountryDetails(code, callback: {(result, error) in
 if let error = error {
 DispatchQueue.main.async(execute: {
 ErrorHandler.handler.showError(error, sender: self)
 })
 return
 }
 if let newContry = result {
 listOfCountries.append(newContry)
 DispatchQueue.main.async(execute: {
 self.neighbouringCountries = listOfCountries
 self.neighbouringCountriesTableView.reloadData()
 })
 }
 })
 }
 }

 //MARK: - Actions

 @IBAction func didTapRegionView(_ sender: AnyObject) {
 regionViewIsShown = !regionViewIsShown
 }

 @IBAction func didTapBordersView(_ sender: AnyObject) {
 tableViewIsShown = !tableViewIsShown
 }

 //MARK: - Animations

 func showRegionCollectionView() {
 regionView.backgroundColor = StyleManager.Colors().standardBlue
 regionArrowView.setActive()
 regionIconView.setActive()
 regionTitle.textColor = UIColor.white
 regionLabel.textColor = UIColor.white
 UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 50, options: UIViewAnimationOptions(), animations: { () in
 self.regionViewHeightConstr.constant = 135
 self.separator.isHidden = false
 self.view.layoutIfNeeded() },
 completion: {(finished: Bool) in

 })
 }

 func hideRegionCollectionView() {
 regionView.backgroundColor = UIColor.clear
 regionTitle.textColor = UIColor.black
 regionLabel.textColor = UIColor.black
 regionIconView.setInactive()
 regionArrowView.setInactive()

 UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 50, options: UIViewAnimationOptions(), animations: { () in
 self.regionViewHeightConstr.constant = 0
 self.separator.isHidden = true
 self.view.layoutIfNeeded() },
 completion: {(finished: Bool) in
 self.scroll.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
 })
 }


 func showTableView() {
 bordersView.backgroundColor = StyleManager.Colors().standardBlue
 borderIconView.setActive()
 borderArrowView.setActive()
 borderTitle.textColor = UIColor.white
 borderLabel.textColor = UIColor.white
 self.neighbouringTVHeightConstr.constant = self.neighbouringCountriesTableView.contentSize.height
 self.neighbouringCountriesTableView.layoutIfNeeded()
 }

 func hideTableView() {
 bordersView.backgroundColor = UIColor.clear
 borderIconView.setInactive()
 borderArrowView.setInactive()
 borderTitle.textColor = UIColor.black
 borderLabel.textColor = UIColor.black

 UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 2.0 , initialSpringVelocity: 20, options: UIViewAnimationOptions(), animations: { () in
 self.neighbouringTVHeightConstr.constant = 0
 self.neighbouringCountriesTableView.layoutIfNeeded() },
 completion: {(finished: Bool) in
 self.scroll.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)        })
 }
 }



 extension CountryDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

 func numberOfSections(in collectionView: UICollectionView) -> Int {
 return 1
 }

 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 guard let _ = region else {return 0}
 return (region?.countryList!.count)!
 }

 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCollectionCell", for: indexPath) as! DetailCollectionCell

 cell.populateWithCountry((region?.countryList![indexPath.row])!)
 cell.drawLayout()
 return cell
 }
 }

 extension CountryDetailsViewController: UITableViewDelegate, UITableViewDataSource {

 func numberOfSections(in tableView: UITableView) -> Int {
 guard neighbouringCountries.count > 0 else {return 0}
 return 1
 }

 func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
 if tableView.numberOfRows(inSection: section) > 0 {
 return tableView.dequeueReusableCell(withIdentifier: "sectionHeader")
 } else {
 return nil
 }
 }

 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return neighbouringCountries.count
 }

 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell") as! CountryListTableViewCell
 cell.populateWith(neighbouringCountries[indexPath.row])
 cell.formatCell()
 return cell
 }

 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 return 105.0
 }

 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 country = neighbouringCountries[indexPath.row]
 tableViewIsShown = false
 scroll.scrollRectToVisible(CGRect(x: scroll.bounds.origin.x, y: scroll.bounds.origin.y, width: scroll.bounds.size.width, height: scroll.bounds.size.height), animated: true)
 setupView()
 view.layoutIfNeeded()
 }
 }
 */
