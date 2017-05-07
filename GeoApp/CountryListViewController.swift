//
//  MainPageViewController.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class CountryListViewController: UIViewController {

    lazy var rootView: CountryListTableView = {
        self.view as! CountryListTableView
    }()

    lazy var viewModel: CountryListViewModel = {
        let viewModel = CountryListViewModel(Store.shared.countries)
        viewModel.delegate = self
        return viewModel
    }()

   // var selectedCountry: CountryDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Colors.standardBlue, NSFontAttributeName: StyleManager.Fonts().titleLarge]
        title = "Countries"
        rootView.setUpView()
        rootView.delegate = self
        viewModel.loadData()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "detailViewSegue" else {return}
        if let countryList = viewModel.loadedCountryList {
        let detailViewController = segue.destination as! CountryDetailsViewController
        detailViewController.countries = countryList.list
        }
        viewModel.resetSelectedState()
    }
}

extension CountryListViewController: ViewModelDelegate {

    func viewModelIsLoading(viewModel: ViewModel) {
        if !rootView.refreshControl.isRefreshing {
            rootView.indicator.startAnimating()
        }
    }

    func viewModelDidLoadData<T>(data: T,viewModel: ViewModel) {
        if let data = data as? CountryListRepresentable {
            self.rootView.data = data
            self.rootView.indicator.stopAnimating()
            self.rootView.refreshControl.endRefreshing()
        }
    }

    func viewModelDidFailWithError(error: Errors, viewModel: ViewModel) {
        self.rootView.indicator.stopAnimating()
        self.rootView.refreshControl.endRefreshing()
        ErrorHandler.handler.showError(error, sender: self, delegate: self, buttonTitle: "Retry")
    }
}

extension CountryListViewController: CountryListViewDelegate {
    func viewDidRequestDataUpdate() {
        viewModel.refreshData()
    }

    func viewDidSelectCountry(countryName: String) {
        if let country = viewModel.loadedCountryList?.list?.first(where: { $0.name == countryName }) {
            country.isSelected = true
            self.performSegue(withIdentifier: "detailViewSegue", sender: self)
        }
    }
}

extension CountryListViewController: ErrorHandlerDelegate {
    func alertDidCancel() {
        viewModel.loadData()
    }
}
