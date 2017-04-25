//
//  ViewController.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.


import Foundation

enum Result {
    case success(InstantiatableFromResponse)
    case error(Errors)
}

struct Endpoints {

    private static let baseURL = "https://restcountries.eu/rest/v2"
    
    static let allCountries = "/all"

    static func countryDetails(_ countryCode: String) -> String {
        return "/alpha/\(countryCode)"
    }

    static func region(_ regionName: String) -> String {
        return "/region/\(regionName)"
    }

    static func flagURLString(_ countryCode: String) -> String {
        let code = countryCode.uppercased()
        return "http://www.geognos.com/api/en/countries/flag/\(code).png"
    }

    static func url(from endpoint: String) -> URL? {
        return URL(string: baseURL + endpoint)
    }
}

final class ConnectionManager {
    static let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)


    static func fetch(url: URL?, constructor: DataConstructor, callback: @escaping (_ result: Result) -> ()) {
        guard let url = url else {
            callback(.error(.invalidURL))
            return
        }
        var urlRequest = URLRequest(url: url)
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
            constructor.instantiateFromResponse(responseData, callback: { response in
                switch response {
                case .failure:
                    callback(.error(.jsonError))
                case let .success(object):
                    callback(.success(object))
                }
            })
        })
        task.resume()
    }
}
