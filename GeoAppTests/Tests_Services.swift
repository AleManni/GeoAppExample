//
//  GeoAppTests.swift
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import XCTest
@testable import GeoApp

class GeoAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //MARK: - Factory tests
    
    func testFactory_deserializeJSON() {
        // GIVEN
        var countryList: CountryList?
        let factory = Factory(CountryList.self)
        guard let mockCountryListData = MockDataFactory.data(from: .countryList) else {
            XCTFail("Failed loading data from json file")
            return
        }

        // WHEN
        factory.instantiateFromResponse(mockCountryListData, callback: { result in
            switch result {
            case let .success(object):
                countryList = object as? CountryList
                break
            case let .failure(error):
                XCTFail(error.description)
            }
    })
        //THEN
        // Assert that the list contains the expected number of countries
        XCTAssertEqual(countryList?.list?.count, 13)
        // Assert that the list contains the expected countries (will only check names)
        let countriesFetched = countryList?.list?.flatMap { return $0.name }
        XCTAssertTrue(countriesFetched! ~ MockObjects.shared.countryListNames, "The fetched list does not contain all the expected countries")
        // Assert that countries have been instantiated as expected (will only check one)
        XCTAssertEqual(countryList?.list?[0], MockObjects.shared.Afghanistan)
    }

    func testFactory_deserializeIncompleteJSON() {
        // GIVEN
        var error: Errors?
        let factory = Factory(CountryList.self)
        guard let mockCountryListData = MockDataFactory.data(from: .countryListCorrupted) else {
            XCTFail("Failed loading data from json file")
            return
        }

        // WHEN
        factory.instantiateFromResponse(mockCountryListData, callback: { result in
            switch result {
            case .success(_):
                XCTFail("Factory should not initialise objects whose json is incomplete")
                break
            case let .failure(resultError):
                error = resultError
            }
        })
        //THEN
        // Assert that the instantiaton failed 
        guard let returnedError = error else {
            XCTFail("Factory should have failed and returned an error")
            return
        }
        // Assert that the correct error case is thrown
        switch returnedError {
        case .jsonError:
            break // Succeed
        default:
            XCTFail("Error returned is of unexpected type")
        }
    }

    //MARK: - Network manager tests
    //Note - This set of tests keeps the API in check. This is fundamental because we are using an external, unowned API that could change at any time producing unexpected results. Ideally this set should be completed leveraging a mock API for offline testing (future implementation)

    func testNetworkManager_fetchCountryList() {
        var countryList = CountryList()
        weak var expectationForCallBack = expectation(description: "Wait for NetworkManager callback")

        //WHEN
        NetworkManager.fetchCountryList(callback: { result in
            switch result {
            case let .success(list):
                countryList = list as! CountryList
                expectationForCallBack?.fulfill()
                break
            case .error:
                XCTFail("Network manager failed to fetch country list")
                break
            }

        })

        // THEN
        waitForExpectations(timeout: 2, handler: { error in
            if let error = error {
                XCTFail("Error while waiting: \(error)")
            }
        })
        // Assert that the list contains the expected number of countries
        XCTAssertEqual(countryList.list?.count, 250, "Expected 250 countries, returned \(String(describing: countryList.list?.count))")
    }

    func testNetworkManager_fetchRegionCountryList() {
        var regionCountryList = CountryList()
        weak var expectationForCallBack = expectation(description: "Wait for NetworkManager callback")

        //WHEN
        NetworkManager.fetchRegion(regionName: "Asia") { result in
            switch result {
            case let .success(list):
                regionCountryList = list as! CountryList
                expectationForCallBack?.fulfill()
                break
            case .error:
                XCTFail("Network manager failed to fetch country list")
                break
            }
        }

        // THEN
        waitForExpectations(timeout: 2, handler: { error in
            if let error = error {
                XCTFail("Error while waiting: \(error)")
            }
        })
        // Assert that the list contains the expected number of countries
        XCTAssertEqual(regionCountryList.list?.count, 50, "Expected 50 countries, returned \(String(describing: regionCountryList.list?.count))")
    }

    //MARK: - Store tests
    func testStore_fetchAndClear() {
        weak var expectationForCallBack = expectation(description: "Wait for NetworkManager callback")

        //WHEN
        Store.shared.fetchAll() { result in
            switch result {
            case .success:
                expectationForCallBack?.fulfill()
                break
            case .error:
                XCTFail("Store failed to fetch country list")
                break
            }
        }

        // THEN
        waitForExpectations(timeout: 2, handler: { error in
            if let error = error {
                XCTFail("Error while waiting: \(error)")
            }
        })
        // Assert that the list contains the expected number of countries
        XCTAssertEqual(Store.shared.countries.list?.count, 250, "Expected 250 countries, returned \(String(describing: Store.shared.countries.list?.count))")

        //WHEN
        Store.shared.clear()
        //THEN
        XCTAssertEqual(Store.shared.countries.list?.count, 0, "Expected 0 countries after clearing, still owning \(String(describing: Store.shared.countries.list?.count)) countries)")
    }
}
