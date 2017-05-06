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

    func testImageFromURL_imageFound() {
        // GIVEN
        let imageView = UIImageView()
        let url = URL(string: "http://www.geognos.com/api/en/countries/flag/AM.png")
        let placeholder = #imageLiteral(resourceName: "placeholder")
        weak var expectationForCallBack = expectation(description: "Wait for NetworkManager callback")

        //WHEN
        imageView.setImageFromURL(url, placeHolder: placeholder) { completed in
            expectationForCallBack?.fulfill()
        }
        //THEN
        waitForExpectations(timeout: 3, handler: { error in
            if let error = error {
                XCTFail("Error while waiting: \(error)")
            }
        })
        // Assert that an image has been set
        XCTAssertTrue(imageView.image != nil, "Image has not been set")
        // Assert that the image set is not the placeholder
        XCTAssertFalse(imageView.image == #imageLiteral(resourceName: "placeholder"))
    }

    func testImageFromURL_imageNotFound() {
        // GIVEN
        let imageView = UIImageView()
        let url = URL(string: "http://www.geognos.com/api/en/countries/flag/AMGHLDK.png")
        let placeholder = #imageLiteral(resourceName: "placeholder")
        weak var expectationForCallBack = expectation(description: "Wait for NetworkManager callback")

        //WHEN
        imageView.setImageFromURL(url, placeHolder: placeholder) { completed in
            expectationForCallBack?.fulfill()
        }
        //THEN
        waitForExpectations(timeout: 3, handler: { error in
            if let error = error {
                XCTFail("Error while waiting: \(error)")
            }
        })
        // Assert that an image has been set
        XCTAssertTrue(imageView.image != nil, "Image has not been set")
        // Assert that the image set is not the placeholder
        XCTAssertTrue(imageView.image == #imageLiteral(resourceName: "placeholder"))
    }

    func testDictionaryValuesExtractor() {
        // GIVEN 
        let stringA = randomString(withLength: 8)
        let stringB = randomString(withLength: 5)
        let stringC = randomString(withLength: 8)
        let stringD = randomString(withLength: 5)

        let dictionaryA: [String: Any] = ["key1": stringA, "key2": stringB, "key3": stringC]
        let dictionaryB: [String: Any] = ["key1": stringD, "key2": stringB]
        let dictionaryC: [String: Any] = ["key0": stringA]
        let dictionaryD: [String: Any] = ["key2": stringC]

        let dictionariesArray = [dictionaryA, dictionaryB, dictionaryC, dictionaryD]

        //WHEN
        let valuesArray = dictionariesArray.values(of: "key1")

        //THEN
        //Assert that the array contains the correct values
        XCTAssertEqual(valuesArray[0] as! String, stringA, "The array does not contain the expected values")
        XCTAssertEqual(valuesArray[1] as! String, stringD, "The array does not contain the expected values")
        //Assert that the array does not contain extraneous values
        XCTAssertTrue(valuesArray.count == 2, "The array contains more values than the expected ones. Expected 2, returned \(valuesArray.count)")
    }

    func testArrayOperator() {
        // GIVEN
        let stringA = randomString(withLength: 8)
        let stringB = randomString(withLength: 5)
        let stringC = randomString(withLength: 8)
        let stringD = randomString(withLength: 5)

        let array1 = [stringA, stringB, stringC, stringD]
        let array2 = [stringD, stringC, stringB, stringA]

        // THEN
        XCTAssertTrue(array1 ~ array2, "The two arrays have not been assessed correctly by the operator")

        // GIVEN
        let array3 = [stringA, stringB, stringC]
        let array4 = [stringD, stringC, stringB, stringA]

        // THEN
        XCTAssertFalse(array3 ~ array4, "The two arrays have not been assessed correctly by the operator")
    }
}

