//
//  MainPageViewController.swift
//  ViagogoTest
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ConnectionManager.fetchAllCountries() { (callback) in
            guard callback.error == nil else {
                ErrorHandler.handler.showError(callback.error!, sender: self)
                return
            }
            
            if let arr = callback.response {
        let country = (arr[0])
                print (country.name, country.countryCode, country.flagIconURL, country.population)
                print (country.translations)
            } else {
                
            }
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
