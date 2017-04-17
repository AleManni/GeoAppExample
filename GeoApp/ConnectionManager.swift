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
