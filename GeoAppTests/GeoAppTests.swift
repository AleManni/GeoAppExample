//
//  GeoAppTests.swift
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import XCTest
@testable import GeoApp

class GeoAppTests: XCTestCase {
    var mockResponse: [String: AnyObject] = [:]
    var navController = UINavigationController()
    var countryListVC = CountryListViewController()
    var countryDetailVC = CountryDetailsViewController()
    
    override func setUp() {
        super.setUp()
        let story = UIStoryboard(name: "Main", bundle: Bundle.main)
        navController = story.instantiateInitialViewController() as! UINavigationController
        countryListVC = navController.viewControllers[0] as! CountryListViewController
        let _ = countryListVC.view
        mockResponse = [
            "capital":"capitalString" as AnyObject,
            "area": 0 as AnyObject,
            "timeZones": ["timeZonesString"],
            "callingCodes": ["callingCodesString"],
            "currencies": ["currenciesString"],
            "languages": ["languagesString"],
            "nativeName": "nativeNameString",
            "borders": ["borderStrings"],
            "name": "nameString",
            "translations": ["language":"translation"],
            "population": 0,
            "region": "regionString",
            "altSpellings": ["altSpellingsString"]
        ]
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
        //Given
        let country = CountryDetail()
        //When
        country.instantiateFromResponse(mockResponse)
        //Then
        XCTAssertTrue(country.capital == "capitalString")
        XCTAssertTrue(country.area == 0)
        XCTAssertTrue(country.timeZones?.first == "timeZonesString")
        XCTAssertTrue(country.callingCodes?.first == "callingCodesString")
        XCTAssertTrue(country.currencies?.first == "currenciesString")
        XCTAssertTrue(country.languages?.first == "languagesString")
        XCTAssertTrue(country.nativeName == "nativeNameString")
        XCTAssertTrue(country.borders?.first == "borderStrings")
        XCTAssertTrue(country.name == "nameString")
        XCTAssertTrue(country.translations?["language"] == "translation")
        XCTAssertTrue(country.population == 0)
        XCTAssertTrue(country.region == "regionString")
    }
    
    func testPopulateRegionFromResponse() {
        let region = Region()
        region.instantiateFromResponse([mockResponse])
        XCTAssertTrue(region.countryList!.first!.name == "nameString")
    }
    
    //MARK: - Controllers test
    
    func testCountryListTableviewInitialisation() {
    XCTAssertNotNil(countryListVC.countriesTableView, "CountryTableView not instantiated")
    }
    
    func testCountryListDataSource() {
        //Given
        let country = CountryDetail()
        country.instantiateFromResponse(mockResponse)
        //When
        countryListVC.dataSource = [country]
        let cell = countryListVC.countriesTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CountryListTableViewCell
        //Then
        XCTAssert(countryListVC.countriesTableView.numberOfSections == 1, "Number of sections should be 1")
        XCTAssertTrue(countryListVC.countriesTableView.numberOfRows(inSection: 0) == 1, "Number of rows in section should be 1")
        XCTAssertTrue(cell.countryNameLabel.text == "nameString", "Cell name is not correct")
    }
    
    func testDetailViewControllerPopulateView() {
        //Given
        let story = UIStoryboard(name: "Main", bundle: Bundle.main)
        countryDetailVC = story.instantiateViewController(withIdentifier: "CountryDetailInfoVC") as! CountryDetailsViewController
        let country = CountryDetail()
        country.instantiateFromResponse(mockResponse)
        countryDetailVC.country = country
        let _ = countryDetailVC.view
        //When
        countryDetailVC.setupView()
        //Then
        XCTAssert(countryDetailVC.title == country.name, "CountryDetailVC name should be <Country>")
        XCTAssert(countryDetailVC.capitalLabel.text == "capitalString", "CountryDetailVC capital should be <capitalString>")
        XCTAssert(countryDetailVC.populationLabel.text == "Population: N/A", "Country population should be <Population: N/A>")
        XCTAssert(countryDetailVC.regionLabel.text == "regionString")
        //FIXME: Test to be completed with the remaining labels
    }
    
    
    
    //MARK: - Networking test
    
    func testShowNetworkError() {
        let networkError = NSError(domain: "https://restcountries.eu/", code: 404, userInfo: [NSLocalizedDescriptionKey: "The requested URL was not found on this server"])
        let errorArray = [Errors.jsonError, Errors.noData, Errors.networkError(nsError: networkError)]
        let errorModel = ErrorHandler()
        for error in errorArray {
            switch error {
            case .jsonError:
                errorModel.showError(error, sender: UIViewController())
                let textLabel = errorModel.alert!.subTextLabel.text
                XCTAssertEqual(textLabel, "Response from server cannot be converted in readable data", "jsonError message did not display correctly")
                errorModel.viewIsShown(false)
                
            case .noData:
                errorModel.showError(error, sender: UIViewController())
                let  textLabel = errorModel.alert!.subTextLabel.text
                XCTAssertEqual(textLabel, "No valid data returned from server", "noData error message did not display correctly")
                errorModel.viewIsShown(false)
                
            case .networkError(nsError: networkError):
                errorModel.showError(error, sender: UIViewController())
                let  textLabel = errorModel.alert!.subTextLabel.text
                XCTAssertEqual(textLabel, "The requested URL was not found on this server", "Network error 404 did not display correctly")
                errorModel.viewIsShown(false)
                
            default:
                XCTFail("Unexpected error in mock array")
            }
        }
    }
    
    func testPopulateDataSource() {
        //Given
        class TestCountryListViewController: CountryListViewController {
            var expectationForCallBack: XCTestExpectation?
            var result: [CountryDetail]?
            
            override func populateDataSource() {
                ConnectionManager.fetchAllCountries() { (result, error) in
                    if let error = error {
                        ErrorHandler.handler.showError(error, sender: self)
                        self.expectationForCallBack?.fulfill()
                        return
                    }
                    DispatchQueue.main.async {
                        if let result = result {
                        self.result = result
                        self.expectationForCallBack?.fulfill()
                        return
                    }
                    }
                }
            }
        }
        let controller = TestCountryListViewController()
        //When
        controller.expectationForCallBack = expectation(description: "Finished fetching all countries")
        controller.populateDataSource()
        //Then
        waitForExpectations(timeout: ConnectionManager.session.configuration.timeoutIntervalForResource, handler: { (error) in
            XCTAssertNil(error, "Timeout error")})
        XCTAssertNotNil(controller.result)
        if let testResult = controller.result {
            XCTAssert(testResult.count > 0, "The result array is empty!")
        }
    }
    
}
