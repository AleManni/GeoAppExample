//
//  Test_ViewModels.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/05/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import XCTest
@testable import GeoApp

extension GeoAppTests {

    // MARK: CountryListViewModel and CountryRepresentable

    func testCountryListViewModel_initialisation() {
        // GIVEN
        let countryListUnsafe = try? CountryList(MockObjects.shared.countryListRawDictionary as AnyObject)
        guard let countryList = countryListUnsafe else {
            XCTFail("Failed to initialise CountryList object")
            return
        }
        let model = CountryListViewModel(countryList!)

        // WHEN
        model.loadData()

        // THEN
        guard let list = model.loadedCountryList?.list else {
            XCTFail("loadedCountryList has not been initialised")
            return
        }
        XCTAssertEqual(list.count, 2, "model loadedCountryList cntains the wrong number of elements. Expected 2, provided \(list.count)")

        // GIVEN
        list[1].isSelected = true
        // WHEN
        model.resetSelectedState()
        // THEN
        XCTAssertFalse(list[1].isSelected, "resetSelectedState() has been called but the item is still selected")
    }

    func testCountryListViewModel_delegation() {
        // GIVEN
        let countryListUnsafe = try? CountryList(MockObjects.shared.countryListRawDictionary as AnyObject)
        guard let countryList = countryListUnsafe else {
            XCTFail("Failed to initialise CountryList object")
            return
        }
        let model = CountryListViewModel(countryList!)
        let delegate = mockViewModelDelegate()
        model.delegate = delegate

        // WHEN
        model.loadData()

        // THEN
        // Assert that the correct representable object is passed to the delegate
        XCTAssertTrue(delegate.loadedData is [CountryRepresentable])
        // Assert that the representable array contains the correct number of items
        let loadedData = delegate.loadedData as! [CountryRepresentable]
        XCTAssertEqual(loadedData.count, 2, "The number of countryRepresentable provided to the delegate is not correct. Expected 2, provided \(loadedData.count)")
        // Assert that the representable array contains the correct items
        XCTAssertEqual(loadedData[0].name, "Afghanistan", "The first item provided to the delegate is not correct. Expected 'Afghanistan', provided \(loadedData[0].name)")
        XCTAssertEqual(loadedData[1].name, "Armenia", "The first item provided to the delegate is not correct. Expected 'Armenia', provided \(loadedData[1].name)")
    }

    func testCountryRepresentable_initialisation() {
        // GIVEN
        var representable: CountryRepresentable?
        // WHEN
        representable = CountryRepresentable(MockObjects.shared.neverLand)

        // THEN
        XCTAssertEqual(representable!.name, "NeverLand")
        XCTAssertEqual(representable!.population, "Population: 0.000M")
        XCTAssertEqual(representable!.region, "Blue sky")
        XCTAssertEqual(representable!.flagImageURL, URL(string: "http://www.geognos.com/api/en/countries/flag/NLD.png"))
    }

    // MARK: CountryDetailsViewModel and CountryDetailsRepresentable

    func testCountryDetailsViewModel_delegationAndSwapSource() {
        // GIVEN
        let model = CountryDetailsViewModel(MockObjects.shared.neverLand)
        let delegate = mockViewModelDelegate()
        model.delegate = delegate

        // WHEN
        model.loadData()

        // THEN
        // Assert that the correct representable object is passed to the delegate
        XCTAssertTrue(delegate.loadedData is CountryDetailsRepresentable)
        XCTAssertEqual((delegate.loadedData as! CountryDetailsRepresentable).nativeName, "HocusPocus")

        // WHEN
        model.swapSource(MockObjects.shared.afghanistan)
        // THEN
        XCTAssertEqual((delegate.loadedData as! CountryDetailsRepresentable).nativeName, "افغانستان")

    }

    func testCountryDetailsRepresentable_initialisation() {
        // GIVEN
        var representable: CountryDetailsRepresentable?
        // WHEN
        representable = CountryDetailsRepresentable(MockObjects.shared.neverLand)

        // THEN
        XCTAssertEqual(representable!.nativeName, "HocusPocus")
        XCTAssertEqual(representable!.population, "Population: 0.000M")
        XCTAssertEqual(representable!.languages, "NEVERLANDIAN")
        XCTAssertEqual(representable!.flagImageURL, URL(string: "http://www.geognos.com/api/en/countries/flag/NLD.png"))
        XCTAssertEqual(representable!.currency, "Apples")
        XCTAssertEqual(representable!.phoneLabel, "999")
        XCTAssertEqual(representable!.timeZone, "UTC+00:01")
    }

    // MARK: CapitalCityViewModel and CapitalCityRepresentable

    func testCapitalCityViewModel_delegation() {
        // GIVEN
        let model = CapitalCityViewModel(MockObjects.shared.neverLand)
        let delegate = mockViewModelDelegate()
        model.delegate = delegate

        // WHEN
        model.loadData()

        // THEN
        // Assert that the correct representable object is passed to the delegate
        XCTAssertTrue(delegate.loadedData is CapitalCityRepresentable)
        XCTAssertEqual((delegate.loadedData as! CapitalCityRepresentable).capital, "Neverland City")
    }

    func testCapitalCityRepresentable_initialisation() {
        // GIVEN
        var representable: CapitalCityRepresentable?
        // WHEN
        representable = CapitalCityRepresentable(MockObjects.shared.neverLand)

        // THEN
        XCTAssertEqual(representable!.capital, "Neverland City")
        XCTAssertEqual(representable!.region, "Blue sky")
    }

    // MARK: RegionCountriesCollectionViewModel and CountryRegionRepresentable

    func testRegionCountriesCollectionViewModel_delegation() {
        // GIVEN
        let model = RegionCountriesCollectionViewModel(MockObjects.shared.afghanistan)
        let delegate = mockViewModelDelegate()
        weak var expectationForCallBack = expectation(description: "Wait for model to Load Data")
        delegate.expectation = expectationForCallBack
        model.delegate = delegate

        // WHEN
        model.loadData()

        //THEN
        waitForExpectations(timeout: 4, handler: { error in
            if let error = error {
                XCTFail("Error while waiting: \(error)")
            }
        })
        // Assert that the correct representable object is passed to the delegate
        XCTAssertTrue(delegate.loadedData is [CountryRegionRepresentable])
        XCTAssertEqual((delegate.loadedData as! [CountryRegionRepresentable]).count, 50)
    }

    func testCountryRegionRepresentable_initialisation() {
        // GIVEN
        var representable: CountryRegionRepresentable?
        // WHEN
        representable = CountryRegionRepresentable(MockObjects.shared.neverLand)

        // THEN
        XCTAssertEqual(representable!.countryCode, "NLD")
        XCTAssertEqual(representable!.regionName, "BLUE SKY COUNTRIES:")
        XCTAssertEqual(representable!.flagImageURL, URL(string: "http://www.geognos.com/api/en/countries/flag/NLD.png"))
    }

    // MARK: RegionCountriesCollectionViewModel

    func testBorderingCountriesViewModel_delegation() {
        // GIVEN
        let model = BorderingCountriesViewModel(MockObjects.shared.afghanistan)
        let delegate = mockViewModelDelegate()
        model.delegate = delegate
        weak var expectationForCallBack = expectation(description: "Wait for model to load data")
        delegate.expectation = expectationForCallBack

        // WHEN
        model.loadData()
        // THEN
        waitForExpectations(timeout: 10, handler: { error in
            if let error = error {
                XCTFail("Error while waiting: \(error)")
            }
        })
        // Assert that the correct representable object is passed to the delegate
        XCTAssertTrue(delegate.loadedData is [CountryRepresentable])
        // Assert that the representable array contains the correct number of items
        guard let loadedData = delegate.loadedData as? [CountryRepresentable] else {
            XCTFail("Delegate did not receive data from model")
            return
        }
        XCTAssertEqual(loadedData.count, 6, "The number of countryRepresentable provided to the delegate is not correct. Expected 6, provided \(loadedData.count)")
        // Assert that the representable array contains the correct items
        let expectedArray = ["Iran (Islamic Republic of)", "Pakistan", "Turkmenistan", "Uzbekistan", "Tajikistan", "China"]
        let returnedArray = loadedData.map { $0.name }
        XCTAssertTrue(returnedArray ~ expectedArray, "The array provided to the delegate does not contain the expected items")
    }
}
