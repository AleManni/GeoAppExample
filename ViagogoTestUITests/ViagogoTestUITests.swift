//
//  ViagogoTestUITests.swift
//  ViagogoTestUITests
//
//  Created by Alessandro Manni on 16/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import XCTest

class ViagogoTestUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFlow() {
        let app = XCUIApplication()
        let tableView = app.tables.element
        let exists = NSPredicate(format: "exists == true")
        expectationForPredicate(exists, evaluatedWithObject: tableView, handler: nil)
        waitForExpectationsWithTimeout(10, handler: {(error) in
            XCTAssertNil(error, "Timeout while waiting for tableview to load. >10s")
        })
        XCTAssert(tableView.exists, "Table view not instantiated")
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        let languageslabelStaticText = elementsQuery.staticTexts["languagesLabel"]
        tableView.cells.elementBoundByIndex(10).tap()
        expectationForPredicate(exists, evaluatedWithObject: languageslabelStaticText, handler: nil)
        waitForExpectationsWithTimeout(5, handler: {(error) in
            XCTAssertNil(error, "Waiting for the Detail View to load")})
        XCUIApplication().scrollViews.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).elementBoundByIndex(2).tap()
        let cellsQuery = XCUIApplication().scrollViews.otherElements.collectionViews.cells
        cellsQuery.otherElements.containingType(.StaticText, identifier:"AZ").childrenMatchingType(.Image).element.swipeLeft()
        let element = app.scrollViews.childrenMatchingType(.Other).element
        XCTAssertNotNil(element.childrenMatchingType(.Other).elementBoundByIndex(2))
        element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).elementBoundByIndex(2).images["forwardArrow"].tap()
        let scrollViewsQuery = XCUIApplication().scrollViews
        let newElement = scrollViewsQuery.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1)
        newElement.staticTexts["Neighbouring countries"].tap()
        app.scrollViews.otherElements.tables.staticTexts["Turkey"].tap()
        app.navigationBars["Turkey"].buttons["Countries"].tap()
    }
}






