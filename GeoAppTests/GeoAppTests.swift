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
    
    //MARK: - Factory tests
    
    func testFactory_1() {
        // GIVEN
        var countryList: CountryList?
        let factory = Factory(CountryList.self)
        guard let mockCountryListData = MockDataURLFactory.data(from: .countryList) else {
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
        XCTAssertEqual(countryList?.list?[0].name, "Afghanistan")
    }

}
