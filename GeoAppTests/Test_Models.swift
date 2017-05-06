//
//  Test_Models.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/05/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import XCTest
@testable import GeoApp

extension GeoAppTests {

    func testCountryDetail_initialisation() {
        // WHEN
        let afghanistan = try? CountryDetail(MockObjects.shared.afghanistanRawDictionary as AnyObject)
        // THEN
        // Check that the object has been initialised
        XCTAssertTrue(afghanistan != nil)
        // Check that the object
        XCTAssertEqual(afghanistan!, MockObjects.shared.afghanistan, "The object has not been initialised in the expected way")
    }

    func testCountryDetail_initialisationFailed() {
        // GIVEN
        var rawDictionary = MockObjects.shared.afghanistanRawDictionary
        rawDictionary["name"] = nil
        var afghanistan: CountryDetail?
        var error: Errors?
        // WHEN
        do {
            afghanistan = try CountryDetail(rawDictionary as AnyObject)
        } catch let returnedError {
            error = returnedError as? Errors
        }
        // THEN
        // Assert that the object has not been initialised
        XCTAssertTrue(afghanistan == nil)
        // Assert that the initialiser returned an error
        guard let returnedError = error else {
            XCTFail("Initializer should have failed and returned an error")
            return
        }
        // Assert that the returned error is of the expected type
        switch returnedError {
        case .jsonError:
        break // Succeed
        default:
            XCTFail("Error returned is of unexpected type")
        }
    }

    func testCountryList_initialisation() {
        // WHEN
        let countryList = try? CountryList([MockObjects.shared.afghanistanRawDictionary as Dictionary<String, AnyObject>] as AnyObject)
        // THEN
        // Check that the object has been initialised with the correct number of countries
        XCTAssertEqual(countryList??.list?.count, 1)
        // Check that the object .list contains the correct country
        XCTAssertEqual(countryList??.list?[0], MockObjects.shared.afghanistan, "The object has not been initialised with the correct country")
    }

    func testCountryList_initialisationFailed() {
        // GIVEN
        var rawDictionary = MockObjects.shared.afghanistanRawDictionary
        rawDictionary["name"] = nil
        var error: Errors?
        var countryList: CountryList?
        // WHEN
        do {
            countryList = try CountryList([rawDictionary as Dictionary<String, AnyObject>] as AnyObject)
        } catch let returnedError {
            error = returnedError as? Errors
        }
        // THEN
        // Assert that the object has not been initialised
        XCTAssertTrue(countryList == nil)
        // Assert that the initialiser returned an error
        guard let returnedError = error else {
            XCTFail("Initializer should have failed and returned an error")
            return
        }
        // Assert that the returned error is of the expected type
        switch returnedError {
        case .jsonError:
        break // Succeed
        default:
            XCTFail("Error returned is of unexpected type")
        }
    }
}
