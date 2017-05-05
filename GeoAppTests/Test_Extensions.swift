//
//  Test_Extensions.swift
//  GeoApp
//
//  Created by Alessandro Manni on 05/05/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import XCTest
@testable import GeoApp

extension GeoAppTests {

    //MARK: - String extensions tests
    func testComposeFromArray() {
        let stringsArray = ["Hello", "World"]
        let string = ""
        let composedString = string.composeFromArray(stringsArray)
        XCTAssertTrue(composedString == "Hello World", "Composed string should be: Hello World, not \(composedString)")
    }
}

