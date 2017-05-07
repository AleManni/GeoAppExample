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

enum GenericDataResult {
    case success(Data)
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

    private static var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 10.0
        let session = URLSession(configuration: configuration)
        return session
    }()

    public static func fetchCountryList(completion: @escaping (_ result: Result) -> ()) {
        let constructor = Factory(CountryList.self)
        let url = Endpoints.url(from: Endpoints.allCountries)
        fetch(url: url, constructor: constructor, completion: { result in
            completion(result)
        })
    }

    public static func fetchRegion(regionName: String, completion: @escaping (_ result: Result) -> ()) {
        let constructor = Factory(CountryList.self)
        let url = Endpoints.url(from: Endpoints.region(regionName))
        fetch(url: url, constructor: constructor, completion: { result in
            completion(result)
        })
    }

    public static func fetchData(from url: URL?, completion: @escaping (_ result: GenericDataResult) -> ()) {
        guard let url = url else {
            completion(.failure(.invalidURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData

        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            if let error = error as NSError? {
                completion(.failure(.networkError(error: error)))
                return
            }
            guard let responseData = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(responseData))
        })
        task.resume()
    }

    private static func fetch(url: URL?, constructor: DataConstructor, completion: @escaping (_ result: Result) -> ()) {
        guard let url = url else {
            completion(.failure(.invalidURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData

        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            if let error = error as NSError? {
                completion(.failure(.networkError(error: error)))
                return
            }
            guard let responseData = data else {
                completion(.failure(.noData))
                return
            }
            constructor.instantiateFromResponse(responseData, completion: { response in
                switch response {
                case .failure:
                    completion(.failure(.jsonError))
                case let .success(object):
                    completion(.success(object))
                }
            })
        })
        task.resume()
    }
}
