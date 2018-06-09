//
//  FavoriteTests.swift
//  HomeAwayCodingChallengeTests
//
//  Created by Justin Veach on 6/9/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import XCTest
@testable import HomeAwayCodingChallenge

class FavoriteTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFavorites() {
        let id = UUID().uuidString
        FavoriteStore.shared.toggle(favorited: true, for: id)
        FavoriteStore.shared.checkFavorite(id: id) { result in
            XCTAssert(result == true)
        }
        
        FavoriteStore.shared.toggle(favorited: false, for: id)
        FavoriteStore.shared.checkFavorite(id: id) { result in
            XCTAssert(result == false)
        }
    }
    
}
