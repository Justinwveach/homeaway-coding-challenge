//
//  TypeAheadTests.swift
//  HomeAwayCodingChallengeTests
//
//  Created by Justin Veach on 6/9/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import XCTest
@testable import HomeAwayCodingChallenge

class TypeAheadTests: XCTestCase {
    
    var typeAhead: TypeAheadSearch!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        typeAhead = TypeAheadSearch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddAPIs() {
        let mockAPI = MockAPI(baseURL: "")
        let mockAPI2 = MockAPI(baseURL: "")
        
        typeAhead.add(api: mockAPI)
        typeAhead.add(api: mockAPI2)
        
        XCTAssert(typeAhead.apis.count == 2)
    }
    
    func testAPICall() {
        let mockAPI = MockAPI(baseURL: "")
        typeAhead.add(api: mockAPI)
        
        let listener = Listener()
        typeAhead.delegate = listener
        typeAhead.search(text: "^^")
        
        sleep(1)
        
        XCTAssert(listener.queriedSuccessful == true)
    }
    
    class Listener: NSObject, TypeAheadSearchDelegate {
        
        var queriedSuccessful = false
        
        func canceledSearch() {
            
        }
        
        func queried<T>(results: T) where T : Pagination, T : ResultList {
            if let items = results as? SeatGeekResults {
                if items.getItems().count == 1 {
                    queriedSuccessful = true
                }
            }
        }
    }
}
