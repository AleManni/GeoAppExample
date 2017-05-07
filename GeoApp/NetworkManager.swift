//
//  ViewController.swift
//  GeoApp
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.


import Foundation

enum Result {
    case success(InstantiatableFromResponse)
    case failure(Errors)
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

final class NetworkManager {
    private static let session = URLSession(configuration: URLSessionConfiguration.default)

    public static func fetchCountryList(callback: @escaping (_ result: Result) -> ()) {
    let constructor = Factory(CountryList.self)
    let url = Endpoints.url(from: Endpoints.allCountries)
    fetch(url: url, constructor: constructor, callback: { result in
        callback(result)
        })
    }

    public static func fetchRegion(regionName: String, callback: @escaping (_ result: Result) -> ()) {
    let constructor = Factory(CountryList.self)
    let url = Endpoints.url(from: Endpoints.region(regionName))
        fetch(url: url, constructor: constructor, callback: { result in
            callback(result)
        })
    }

    private static func fetch(url: URL?, constructor: DataConstructor, callback: @escaping (_ result: Result) -> ()) {
        guard let url = url else {
            callback(.failure(.invalidURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        let task = self.session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            if let error = error as NSError? {
                callback(.failure(.networkError(error: error)))
                return
            }
            guard let responseData = data else {
                callback(.failure(.noData))
                return
            }
            constructor.instantiateFromResponse(responseData, callback: { response in
                switch response {
                case .failure:
                    callback(.failure(.jsonError))
                case let .success(object):
                    callback(.success(object))
                }
            })
        })
        task.resume()
    }
}
