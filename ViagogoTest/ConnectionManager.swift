//
//  ViewController.swift
//  ViagogoTest
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.



import Foundation

class ConnectionManager {
    static let session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    static let baseURL = "https://restcountries.eu"

    static func fetchAllCountries (callback: (response: [Country]?, error: Errors?) -> ()) {
        let url = NSURL(string: baseURL + "/rest/v1/all")
        let urlRequest = NSURLRequest(URL: url!)
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            guard error == nil else {
                callback(response: nil, error: Errors.networkError(nsError: error!))
            return
            }
            guard let responseData = data else {
                callback(response: nil, error: Errors.noData)
                return
            }
            var countryList: [Country] = []
            do {
                guard let jasonArray = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as? [[String:AnyObject]] else {
                    callback(response: nil, error: Errors.jsonError)
                    return
                }
                for item in jasonArray {
                    let country = Country()
                    country.populateFromResponse(item)
                    countryList.append(country)
                }
                callback(response: countryList, error: nil)
            } catch  {
                callback(response: nil, error: Errors.jsonError)
                return
            }
        }
        task.resume()
    }
    
    static func fetchCountryDetails (countryName: String, callback: (response: CountryDetail?, error: Errors?) -> ()) {
        let url = NSURL(string: baseURL + "/rest/v1/name/\(countryName)?fullText=true")
        let urlRequest = NSURLRequest(URL: url!)
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            guard error == nil else {
                callback(response: nil, error: Errors.networkError(nsError: error!))
                return
            }
            guard let responseData = data else {
                callback(response: nil, error: Errors.noData)
                return
            }
            do {
                guard let jasonArray = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as? [[String:AnyObject]] else {
                    callback(response: nil, error: Errors.jsonError)
                    return
                }
                    let countryDetail = CountryDetail()
                let countryDict = jasonArray[0]
                    countryDetail.populateFromResponse(countryDict)
                callback(response: countryDetail, error: nil)
            } catch  {
                callback(response: nil, error: Errors.jsonError)
                return
            }
        }
        task.resume()
    }

    
    static func fetchRegion (regionName: String, callback: (response: Region?, error: Errors?) -> ()) {
        let url = NSURL(string: baseURL + "/rest/v1/region/\(regionName)")
        let urlRequest = NSURLRequest(URL: url!)
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            guard error == nil else {
                callback(response: nil, error: Errors.networkError(nsError: error!))
                return
            }
            guard let responseData = data else {
                callback(response: nil, error: Errors.noData)
                return
            }
            do {
                guard let jasonArray = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as? [[String:AnyObject]] else {
                    callback(response: nil, error: Errors.jsonError)
                    return
                }
                let region = Region()
                region.populateFromResponse(jasonArray)
                callback(response: region, error: nil)
            } catch  {
                callback(response: nil, error: Errors.jsonError)
                return
            }
        }
        task.resume()
    }

}




