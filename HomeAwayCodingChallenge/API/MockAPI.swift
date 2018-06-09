//
//  TestAPI.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/9/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper


/// API that will be used for testing
class MockAPI: BaseAPI, SearchAPIDelegate {
    
    func queryItems<T>(with string: String, params: [String : String], completion: @escaping ((T) -> Void)) where T : Pagination, T : ResultList {
        if string == "^^" {
            let event = Event(title: "Test", date: Date())
            
            let results = SeatGeekResults()
            results.append(items: [event])
            completion(results as! T)
        }
    }
    
    func cacheKey() -> String {
        return "MockAPI"
    }
    
}
