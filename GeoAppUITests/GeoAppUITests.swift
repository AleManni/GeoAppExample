//
//  GeoAppUITests.swift
//  GeoAppUITests
//
//  Created by Alessandro Manni on 04/08/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import XCTest


class GeoAppUITests: XCTestCase {
    // MARK: UITests common constants
    let waitTime: UInt32 = 2
    let app = XCUIApplication()
    var countryListTableView: XCUIElement {
    return app.tables["countryListTableView"]
    }
    var countryDetailsRootView: XCUIElement {
        return app.otherElements["countryDetailsRootView"]
    }
    var countryDetailsView: XCUIElement {
        return app.otherElements["countryDetailsView"]
    }
    var capitalCityView: XCUIElement {
        return app.otherElements["capitalCityView"]
    }
    var regionDetailView: XCUIElement {
        return app.otherElements["regionDetailView"]
    }
    var borderingCountriesTableView: XCUIElement {
        return app.otherElements["borderingCountriesTableView"]
    }
    var regionView: XCUIElement {
        return app.otherElements["regionView"]
    }
    var bordersView: XCUIElement {
        return app.otherElements["bordersView"]
    }

    // MARK: UI Tests

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        waitForElementToExist(app)
        XCUIDevice.shared().orientation = .portrait
        navigateToCountryList()
    }

    func testCountryListTableView() {
        let numberOfScolls = 5

        navigateToCountryList()
        guard countryListTableView.isDisplayed else {
            XCTFail("countryListTableView is not displayed!")
            return
        }

        XCTAssertTrue(countryListTableView.cells.count > 0, "CountryListTableView should not be empty!")

        guard countryListTableView.swipe(.up, times: numberOfScolls) else {
            XCTFail("The table view  can not be scrolled up")
            return
        }
        guard countryListTableView.swipe(.down, times: numberOfScolls) else {
            XCTFail("The table view  can not be scrolled down")
            return
        }
    }

    func testDisplayCountryDetails() {
        navigateToCountryDetails()
        XCTAssertTrue(countryDetailsRootView.isDisplayed, "countryDetailsRootView has not been displayed!")
        XCTAssertTrue(countryDetailsView.isDisplayed)
        XCTAssertTrue(capitalCityView.isDisplayed)
        // Note: at page load the following views should not be displayed
        XCTAssertFalse(regionDetailView.exists)
        XCTAssertFalse(borderingCountriesTableView.exists)
    }

    func testRegionCollectionView() {
        let numberOfScolls = 5
        var collectionView: XCUIElement {
            return app.collectionViews["regionCollectionView"]
        }

        navigateToCountryDetails()
        regionView.tap()
        sleep(waitTime)
        XCTAssertTrue(regionDetailView.isDisplayed)
        waitForElementToBeHittable(collectionView)
        sleep(waitTime)

        guard collectionView.swipe(.left, times: numberOfScolls) else {
            XCTFail("The collection view  can not be scrolled left")
            return
        }

        guard collectionView.swipe(.right, times: numberOfScolls) else {
            XCTFail("The collection view  can not be scrolled right")
            return
        }
    }

    func testBorderingCountries_display() {
        navigateToCountryDetails()
        bordersView.tap()
        sleep(waitTime)
        XCTAssertTrue(borderingCountriesTableView.exists, "BorderingCountriesTableView has not been displayed upon tapping the corresponding view")
    }

    func testBorderingCountries_selection() {
        var firstCell: XCUIElement {
        return countryListTableView.cells.element(boundBy: 0)
        }
        var originalPageTitle: String?
        var nativeNameLabel: XCUIElement {
            return app.staticTexts["nativeNameLabel"]
        }

        navigateToCountryDetails()
        originalPageTitle = nativeNameLabel.label
        bordersView.tap()
        waitForElementToBeHittable(firstCell)
        firstCell.tap()
        sleep(waitTime)
        XCTAssertFalse(originalPageTitle == nativeNameLabel.label, "The selected country has not been loaded")
    }

    func testCountryDetailsAnimations() {
        navigateToCountryDetails()
        // Note: at page load the following views should not be displayed
        XCTAssertFalse(regionDetailView.exists)
        XCTAssertFalse(borderingCountriesTableView.exists)

        // Assert animations (stand alone)
        bordersView.tap()
        sleep(waitTime)
        XCTAssertTrue(borderingCountriesTableView.exists)
        bordersView.tap()
        sleep(waitTime)
        XCTAssertFalse(borderingCountriesTableView.exists)

        regionView.tap()
        sleep(waitTime)
        XCTAssertTrue(regionDetailView.exists)
        regionView.tap()
        sleep(waitTime)
        XCTAssertFalse(regionDetailView.exists)

        // Assert animations (interlocked)
        regionView.tap()
        sleep(waitTime)
        XCTAssertTrue(regionDetailView.exists)
        XCTAssertFalse(borderingCountriesTableView.exists)

        bordersView.tap()
        sleep(waitTime)
        XCTAssertTrue(borderingCountriesTableView.exists)
        XCTAssertFalse(regionDetailView.exists)

        regionView.tap()
        sleep(waitTime)
        XCTAssertTrue(regionDetailView.exists)
        XCTAssertFalse(borderingCountriesTableView.exists)
    }

    func testNavigateBackFromCountryDetails() {
        var backButton: XCUIElement {
            return app.navigationBars.buttons.element(boundBy: 0)
        }

        navigateToCountryDetails()
        backButton.tap()
        sleep(waitTime)
        XCTAssertTrue(countryListTableView.isDisplayed, "CountryListTableView is not displayed upon tapping Back from details page")
    }
}

// MARK: UI Navigation utilities
extension GeoAppUITests {

    // Note: network alert skip mechanism 
    func dismissAlert() -> Bool {
        let cancelButton = self.app.alerts["Error"].buttons.element(boundBy: 0)
        if cancelButton.exists {
            cancelButton.tap()
            self.app.tap()
            return true
        } else {
            return false
        }
    }

    func navigateToCountryList() {
        if !countryListTableView.exists {
            while !countryListTableView.exists {
                let dismissed = dismissAlert()
                if !dismissed {
                    return
                }
            }
        } else {
            while !countryListTableView.isHittable {
                let dismissed = dismissAlert()
                if !dismissed {
                    return
                }
            }
        }
    }

    func navigateToCountryDetails() {
        let firstCell = countryListTableView.cells.element(boundBy: 0)
        firstCell.tap()
        sleep(waitTime)
    }
}

