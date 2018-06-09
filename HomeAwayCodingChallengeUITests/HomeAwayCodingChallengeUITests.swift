//
//  HomeAwayCodingChallengeUITests.swift
//  HomeAwayCodingChallengeUITests
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import XCTest

class HomeAwayCodingChallengeUITests: XCTestCase {
    
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
    
    func testSearch() {
        
        let app = XCUIApplication()
        app.navigationBars["HomeAwayCodingChallenge.SearchView"].searchFields["Search for Events, Performers, or Venues"].tap()
        
        let moreKey = app/*@START_MENU_TOKEN@*/.keys["more"]/*[[".keyboards",".keys[\"more, numbers\"]",".keys[\"more\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        moreKey.tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards",".buttons[\"more, symbols\"]",".buttons[\"shift\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let key = app/*@START_MENU_TOKEN@*/.keys["^"]/*[[".keyboards.keys[\"^\"]",".keys[\"^\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        key.tap()
        app.collectionViews.staticTexts["Test"].tap()
        app.navigationBars["Test"].buttons["ic heart"].tap()
        
    }
    
    func testSearchBar() {
        
        let app = XCUIApplication()
        let homeawaycodingchallengeSearchviewNavigationBar = app.navigationBars["HomeAwayCodingChallenge.SearchView"]
        let searchForEventsPerformersOrVenuesSearchField = homeawaycodingchallengeSearchviewNavigationBar.searchFields["Search for Events, Performers, or Venues"]
        searchForEventsPerformersOrVenuesSearchField.tap()
        
        let tKey = app/*@START_MENU_TOKEN@*/.keys["T"]/*[[".keyboards.keys[\"T\"]",".keys[\"T\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey.tap()
        
        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
        homeawaycodingchallengeSearchviewNavigationBar.buttons["Cancel"].tap()
        searchForEventsPerformersOrVenuesSearchField.tap()
        
        let sKey = app/*@START_MENU_TOKEN@*/.keys["S"]/*[[".keyboards.keys[\"S\"]",".keys[\"S\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()
        
        let tKey2 = app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey2.tap()
        searchForEventsPerformersOrVenuesSearchField.buttons["Clear text"].tap()
        
    }
    
}
