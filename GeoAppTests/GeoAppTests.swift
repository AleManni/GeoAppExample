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
    
    //MARK: - String extensions tests
    
    func testComposeFromArray() {
        let stringsArray = ["Hello", "World"]
        let string = ""
        let composedString = string.composeFromArray(stringsArray)
        XCTAssertTrue(composedString == "Hello World", "Composed string should be: Hello World, not \(composedString)")
    }
    
    //MARK: - Model tests
    
    func testPopulateCountryFromResponse() {

    }
    
    func testPopulateRegionFromResponse() {

    }
    
    //MARK: - Controllers test

    func testCountryListDataSource() {

    }
    
    
    
    //MARK: - Networking test
    
    func testShowNetworkError() {

    }
}
