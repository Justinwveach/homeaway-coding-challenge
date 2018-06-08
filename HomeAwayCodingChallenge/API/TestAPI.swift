//
//  File.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

class TestAPI: BaseAPI, SearchAPIDelegate {
    func urlQueryParam() -> String {
        return ""
    }
    
    
    func queryItems(with string: String, completion: @escaping (([Mappable]) -> Void)) {
        
    }
    
    func mapObject(from json: String) -> Mappable? {
        return nil
    }
    
    func cacheKey() -> String {
        return "TEST"
    }
    
    
}
