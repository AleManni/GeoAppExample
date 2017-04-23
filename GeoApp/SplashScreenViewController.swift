//
//  SplashScreenViewController.swift
//  GeoApp
//
//  Created by Alessandro Manni on 17/04/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation
import UIKit

class SplashScreenViewController: UIViewController {
    @IBOutlet weak var indicator: UIActivityIndicatorView!


    override func viewDidAppear(_ animated: Bool) {
        indicator.startAnimating()
        populateStore()
    }

    fileprivate func populateStore() {
        Store.shared.fetchAll { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.dismissAndSegue()
                }
                break
            case .error(let error):
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    ErrorHandler.handler.showError(error, sender: self, delegate: self)
                }
                break
            }
        }
    }

    private func dismissAndSegue() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NavigationController")
        UIApplication.shared.windows[0].rootViewController = controller
    }
}

extension SplashScreenViewController: ErrorHandlerDelegate {
    func viewDidCancel() {
        populateStore()
    }
}
