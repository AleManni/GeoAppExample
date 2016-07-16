//
//  ViagogoTestTests.swift
//  ViagogoTestTests
//
//  Created by Alessandro Manni on 13/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import XCTest
@testable import ViagogoTest

class ViagogoTestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let story = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let navController = story.instantiateInitialViewController() as! UINavigationController
        let countryListVC = navController.viewControllers[0] as! CountryListViewController
        let _ = countryListVC.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShowError() {
        let networkError = NSError(domain: "https://restcountries.eu/", code: 404, userInfo: [NSLocalizedDescriptionKey: "The requested URL was not found on this server"])
        let errorArray = [Errors.jsonError, Errors.noData, Errors.networkError(nsError: networkError)]
        let errorModel = ErrorHandler()
        for error in errorArray {
            switch error {
            case .jsonError:
                errorModel.showError(error, sender: UIViewController())
                let textLabel = errorModel.alert!.subTextLabel.text
                XCTAssertEqual(textLabel, "Response from server cannot be converted in readable data")
                errorModel.viewIsShown(false)
                
            case .noData:
                errorModel.showError(error, sender: UIViewController())
                let  textLabel = errorModel.alert!.subTextLabel.text
                XCTAssertEqual(textLabel, "No valid data returned from server")
                errorModel.viewIsShown(false)
                
            case .networkError(nsError: networkError):
                errorModel.showError(error, sender: UIViewController())
                let  textLabel = errorModel.alert!.subTextLabel.text
                XCTAssertEqual(textLabel, "The requested URL was not found on this server")
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
            var result: [Country]?
            
            override func populateDataSource() {
                ConnectionManager.fetchAllCountries() { (callback) in
                    guard callback.error == nil else {
                        ErrorHandler.handler.showError(callback.error!, sender: self)
                        self.expectationForCallBack?.fulfill()
                        return
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.result = callback.response! as [Country]
                        self.expectationForCallBack?.fulfill()
                        return
                    }
                }
            }
        }
        let controller = TestCountryListViewController()
        //When
        controller.expectationForCallBack = expectationWithDescription("Finished fetching all countries")
        controller.populateDataSource()
        //Then
        waitForExpectationsWithTimeout(ConnectionManager.session.configuration.timeoutIntervalForResource, handler: { (error) in
            XCTAssertNil(error, "Timeout error")})
        XCTAssertNotNil(controller.result)
        if let testResult = controller.result {
            XCTAssert(testResult.count > 0, "The result array is empty!")
        }
    }
    
}
