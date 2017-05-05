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
    
    func testFactory_1() {
        // GIVEN
        var countryList: CountryList?
        let factory = Factory(CountryList.self)
        guard let mockCountryListData = MockDataFactory.data(from: .countryList) else {
            XCTFail("Failed loading data from json file")
            return
        }
        let expectationForCallBack = XCTestExpectation()

        // WHEN
        factory.instantiateFromResponse(mockCountryListData, callback: { result in
            switch result {
            case let .success(object):
                countryList = object as? CountryList
                break
            case let .failure(error):
                XCTFail(error.description)
            }
            expectationForCallBack.fulfill()
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

    func testFactory_2() {
        // GIVEN
        var error: Errors?
        let factory = Factory(CountryList.self)
        guard let mockCountryListData = MockDataFactory.data(from: .countryListCorrupted) else {
            XCTFail("Failed loading data from json file")
            return
        }
        let expectationForCallBack = XCTestExpectation()

        // WHEN
        factory.instantiateFromResponse(mockCountryListData, callback: { result in
            switch result {
            case .success(_):
                XCTFail("Factory should not initialise objects whose json is incomplete")
                break
            case let .failure(resultError):
                error = resultError
            }
            expectationForCallBack.fulfill()
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
}
