//
//  ViewController.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.


import Foundation

//TODO: Implement result replacing the tuplet in ConnectionManager 

enum Result {
    case success(InstantiatableFromResponse)
    case error(Errors)
}

struct Endpoints {

    static let shared = Endpoints()
    
    let all = "/all"

    func countryDetails(_ countryCode: String) -> String {
        return "/alpha/\(countryCode)"
    }

    func region(_ regionName: String) -> String {
        return "/region/\(regionName)"
    }

    func flagURLString(_ countryCode: String) -> String {
        let code = countryCode.uppercased()
        return "http://www.geognos.com/api/en/countries/flag/\(code).png"
    }
}

class ConnectionManager {
    static let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    static let baseURL = "https://restcountries.eu/rest/v2"

    static func fetch(endPoint: String, constructor: DataConstructor, callback: @escaping (_ result: Result) -> ()) {
        let url = URL(string: baseURL + endPoint)
        var urlRequest = URLRequest(url: url!)
        urlRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            if let error = error as NSError? {
                callback(.error(.networkError(error: error)))
                return
            }
            guard let responseData = data else {
                callback(.error(.noData))
                return
            }
            constructor.instantiateFromResponse(responseData, callback: { (response, error) in
                if (error != nil) {
                    callback(.error(.jsonError))
                } else {
                    callback(.success(response!))
                }
            })
        })
        task.resume()
    }

}

    
//    static func fetchCountryDetails (_ countryCode: String, callback: @escaping (_ response: CountryDetail?, _ error: Errors?) -> ()) {
//        let url = URL(string: baseURL + "/alpha/\(countryCode)")
//        let urlRequest = URLRequest(url: url!)
//        let task = session.dataTask(with: urlRequest, completionHandler: {
//            (data, response, error) in
//            guard error == nil else {
//                callback(nil, Errors.networkError(nsError: error! as NSError))
//                return
//            }
//            guard let responseData = data else {
//                callback(nil, Errors.noData)
//                return
//            }
//            do {
//                guard let jasonDict = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject] else {
//                    callback(nil, Errors.jsonError)
//                    return
//                }
//                    var countryDetail = CountryDetail()
//                    countryDetail.instantiateFromResponse(jasonDict)
//                callback(countryDetail, nil)
//            } catch  {
//                callback(nil, Errors.jsonError)
//                return
//            }
//        }) 
//        task.resume()
//    }
//
//    
//    static func fetchRegion (_ regionName: String, callback: @escaping (_ response: Region?, _ error: Errors?) -> ()) {
//        let url = URL(string: baseURL + "/region/\(regionName)")
//        let urlRequest = URLRequest(url: url!)
//        let task = session.dataTask(with: urlRequest, completionHandler: {
//            (data, response, error) in
//            guard error == nil else {
//                callback(nil, Errors.networkError(nsError: error! as NSError))
//                return
//            }
//            guard let responseData = data else {
//                callback(nil, Errors.noData)
//                return
//            }
//            do {
//                guard let jasonArray = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String:AnyObject]] else {
//                    callback(nil, Errors.jsonError)
//                    return
//                }
//                var region = Region()
//                region.instantiateFromResponse(jasonArray)
//                callback(region, nil)
//            } catch  {
//                callback(nil, Errors.jsonError)
//                return
//            }
//        }) 
//        task.resume()
//    }
//}




