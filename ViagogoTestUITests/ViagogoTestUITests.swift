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
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTransitionToDetailViewController() {
        let app = XCUIApplication()
        let tableView = app.tables.element
        let exists = NSPredicate(format: "exists == true")
        expectationForPredicate(exists, evaluatedWithObject: tableView, handler: nil)
        waitForExpectationsWithTimeout(10, handler: {(error) in
            XCTAssertNil(error, "Timeout while waiting for tableview to load. >10s")
        })
        XCTAssert(tableView.exists, "Table view not instantiated")
        
        XCUIApplication().tables.staticTexts["Angola"].swipeUp()
        XCUIApplication().tables.cells.containingType(.StaticText, identifier:"Angola").childrenMatchingType(.StaticText).matchingIdentifier("Angola").elementBoundByIndex(0).swipeUp()
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        let languageslabelStaticText = elementsQuery.staticTexts["languagesLabel"]
        tableView.cells.elementBoundByIndex(10).tap()
        expectationForPredicate(exists, evaluatedWithObject: languageslabelStaticText, handler: nil)
        waitForExpectationsWithTimeout(5, handler: {(error) in
            
            XCTAssertNil(error, "Waiting for the Detail View to load")})
        
        XCUIApplication().scrollViews.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).elementBoundByIndex(2).tap()
        let element = app.scrollViews.childrenMatchingType(.Other).element
        
        XCTAssertNotNil(element.childrenMatchingType(.Other).elementBoundByIndex(2))
        
        element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).elementBoundByIndex(2).images["forwardArrow"].tap()
        
        let scrollViewsQuery = XCUIApplication().scrollViews
        let newElement = scrollViewsQuery.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1)
        newElement.childrenMatchingType(.Other).elementBoundByIndex(2).tap()
        newElement.staticTexts["Neighbouring countries"].tap()
        app.scrollViews.otherElements.tables.staticTexts["Turkey"].tap()
        app.navigationBars["Turkey"].buttons["Countries"].tap()
        
    }
}




    

