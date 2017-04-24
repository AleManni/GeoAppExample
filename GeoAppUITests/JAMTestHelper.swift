//
//  JAMTestHelper.swift
//  JAMTestHelper
//
//  Created by Joe Masilotti on 7/6/15.
//  Copyright © 2015 Masilotti.com. All rights reserved.
//

import Foundation
import XCTest

/**
 * Adds a few methods to XCTest geared towards UI Testing in Xcode 7 and iOS 9.
 *
 * Import this extension into your UI Testing tests to wait for elements and
 * activity items to appear or dissappear.
 *
 * @note The default timeout is two seconds.
 */
extension XCTestCase {
    /**
     * Waits for the default timeout until `element.exists` is true.
     *
     * @param element the element you are waiting for
     * @see waitForElementToNotExist()
     */
    func waitForElementToExist(_ element: XCUIElement) {
        waitForElement(element, toExist: true)
    }

    /**
     * Waits for the default timeout until `element.exists` is false.
     *
     * @param element the element you are waiting for
     * @see waitForElementToExist()
     */
    func waitForElementToNotExist(_ element: XCUIElement) {
        waitForElement(element, toExist: false)
    }

    func waitForElementToBeHittable(_ element: XCUIElement) {
        waitForElement(element, toBeHittable: true)
    }

    /**
     * Waits for the default timeout until the activity indicator stop spinning.
     *
     * @note Should only be used if one `ActivityIndicator` is present.
     */
    func waitForActivityIndicatorToFinish() {
        let spinnerQuery = XCUIApplication().activityIndicators

        let expression = { () -> Bool in
            return (spinnerQuery.element.value! as AnyObject).intValue != 1
        }
        waitFor(expression, failureMessage: "Timed out waiting for spinner to finish.")
    }

    // MARK: Private

    fileprivate func waitForElement(_ element: XCUIElement, toExist: Bool) {
        let expression = { () -> Bool in
            return element.exists == toExist
        }
        waitFor(expression, failureMessage: "Timed out waiting for element to exist.")
    }

    fileprivate func waitForElement(_ element: XCUIElement, toBeHittable: Bool) {
        let expression = { () -> Bool in
            return element.isHittable == toBeHittable
        }
        waitFor(expression, failureMessage: "Timed out waiting for element to be hittable")
    }

    fileprivate func waitFor(_ expression: () -> Bool, failureMessage: String) {
        let startTime = Date.timeIntervalSinceReferenceDate

        while (!expression()) {
            if (Date.timeIntervalSinceReferenceDate - startTime > 120.0) {
                raiseTimeOutException(failureMessage)
            }
            CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 0.1, Bool(0))
        }
    }

    fileprivate func raiseTimeOutException(_ message: String) {
        NSException(name: NSExceptionName(rawValue: "JAMTestHelper Timeout Failure"), reason: message, userInfo: nil).raise()
    }

    // Clear text in textfield or secureTextField - NB At the moment this function works only if the field has a single (delete) button
    func clearTextIn(field: XCUIElement) -> Bool {
        guard field.elementType == .textField || field.elementType == .secureTextField, field.value != nil, field.buttons.count == 1 else { return false }
        field.tap()
        let clearButton = field.buttons.element(boundBy: 0)
        guard clearButton.exists else {
            return false
        }
        clearButton.tap()
        return true
    }

    func randomString(withLength length: Int) -> String {

        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }

}

extension XCUIElement {

    enum Direction {
        case up
        case down
        case left
        case right
    }

    var isDisplayed: Bool {
        if self.exists {
            let window = XCUIApplication().windows.element(boundBy: 0)
            XCTAssertTrue(window.exists, "App window not present. The app may have crashed")
            return window.frame.contains(self.frame)
        } else {
            return false
        }
    }

    @discardableResult
    func swipe(_ direction: Direction, times: Int) -> Bool {
        guard times > 0 else {
            return false
        }

        for _ in 1...times {
            switch direction {
            case .up:
                self.swipeUp()
            case .down:
                self.swipeDown()
            case .left:
                self.swipeLeft()
            case .right:
                self.swipeRight()
            }
        }
        return true
    }
    
}
