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

    // Note: The following tests set assume the app has EN as preferred language
    func testLocalisedName_localisedStringExists() {
        // GIVEN
        let translationDictonary = ["de": "German translation",
                                   "es": "Spanish translaton",
                                   "fr": "French translation",
                                   "ja": "Japanese translation",
                                   "en": "English translation"]
        let original = randomString(withLength: 8)

        //WHEN
        let translated = original.localisedName(translationDictonary)

        //THEN
        XCTAssertEqual(translated, "English translation", "The string has not been translated as expected")
    }

    func testLocalisedName_localisedStringDoesNotExists() {
        // GIVEN
        let translationDictonary = ["de": "German translation",
                                    "es": "Spanish translaton",
                                    "fr": "French translation",
                                    "ja": "Japanese translation"]
        let original = randomString(withLength: 8)

        //WHEN
        let translated = original.localisedName(translationDictonary)

        //THEN
        XCTAssertEqual(translated, original, "Translaton does not exist and a copy of the original string should have been returned")
    }
}

