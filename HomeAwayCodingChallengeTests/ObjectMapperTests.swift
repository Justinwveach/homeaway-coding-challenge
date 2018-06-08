//
//  ObjectMapperTests.swift
//  HomeAwayCodingChallengeTests
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import XCTest
@testable import HomeAwayCodingChallenge
import ObjectMapper


class ObjectMapperTests: XCTestCase {
    
    let performerOneId = 39393
    let performerOneName = "Gary Clark Jr"
    let performerImage = "https://url.for.image"
    let performerOnePrimary = true
    
    let performerTwoId = 30888
    
    var eventJson = ""
    var performerJson = ""
    var performerImages = ""
    var venueJson = ""
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        venueJson = "{\"id\" : \(1322), \"name\": \"Austin City Limits\", \"city\" : \"Austin\", \"state\" : \"TX\", \"country\" : \"US\"}"
        
        performerImages = "{\"small\" : \"\(performerImage)\", \"medium\" : \"\(performerImage)\", \"large\" : \"\(performerImage)\", \"huge\" : \"\(performerImage)\"}"
        
        performerJson = "{\"id\" : \(performerOneId), \"name\" : \"\(performerOneName)\", \"image\" : \"\(performerImage)\", \"images\" : \(performerImages), \"primary\" : \(performerOnePrimary)}"
        
        eventJson = "{\"title\" : \"Test\", \"id\" : \(814), \"datetime_local\" : \"2012-03-09T19:00:00\", \"venue\" : \(venueJson), \"performers\" : [\(performerJson)]}"
        
        //json = JSON(jsonString)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEventMapper() {
        //let dict: Dictionary = convertToDictionary(text: jsonString)! as Dictionary
        if let event = Event(JSONString: eventJson) {
            assert(event.title == "Test")
            assert(event.date != nil)
            assert(event.venue != nil)
            assert((event.performers?.count)! > 0)
            
            if let firstPerformer = event.performers?[0] {
                assert(firstPerformer.name == performerOneName)
                XCTAssert(firstPerformer.id == performerOneId)
                
            } else {
                assertionFailure("Perfomer is incorrect")
            }
        } else {
            assertionFailure("Unable to create Event from json")
        }

    }
    
    func testPerformerMapper() {
        print(performerJson)
        if let performer = Performer(JSONString: performerJson) {
            XCTAssert(performer.name == performerOneName)
            XCTAssert(performer.images?.count == 4)
            XCTAssert(performer.id == performerOneId)
            XCTAssert(!performer.image.isEmpty)
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

}