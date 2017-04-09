//
//  MainPageViewController.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class CountryListViewController: UIViewController {

    lazy var rootView: CountryListRootView = {
        self.view as! CountryListRootView
    }()

    lazy var viewModel: CountryListViewModel = {
        let viewModel = CountryListViewModel()
        viewModel.delegate = self
        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.Colors().standardBlue, NSFontAttributeName: Constants.Fonts().titleLarge]
        title = "Countries"
        rootView.setUpView()
        rootView.delegate = self
        viewModel.loadData()
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "detailViewSegue" else {return}
        let vc = segue.destination as! CountryDetailsViewController
        //  vc.country = selecteCountryDetail
    }
}

extension CountryListViewController: viewModelDelegate {

    func viewModelIsLoading() {
        if !rootView.refreshControl.isRefreshing {
            rootView.indicator.startAnimating()
        }
    }

    func viewModelDidLoadData<T>(data: T) {
        if let data = data as? CountryListRepresentable {
            self.rootView.data = data
            self.rootView.indicator.stopAnimating()
            self.rootView.refreshControl.endRefreshing()
        }
    }

    func viewModelDidFailWithError(error: Errors) {
        ErrorHandler.handler.showError(error, sender: self)
        self.rootView.indicator.stopAnimating()
        self.rootView.refreshControl.endRefreshing()
    }
}

extension CountryListViewController: CountryListRootViewDelegate {
    func rootViewDidRequestDataUpdate() {
        viewModel.loadData()
    }
}



