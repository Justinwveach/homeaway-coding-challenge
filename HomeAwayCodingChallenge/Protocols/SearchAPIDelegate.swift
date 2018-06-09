//
//  SearchAPIDelegate.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol SearchAPIDelegate {
    
    //func queryItems<T>(with string: String, completion: @escaping (([T]) -> Void)) where T : Mappable
    //func queryItems(with string: String, completion: (@escaping (JSON) -> Void))
    func queryItems<T: ResultList & Pagination>(with string: String, params: [String : String], completion: (@escaping (T) -> Void))
    
    //func getObject<T: SearchResult>(json: String) -> T?
    
    func cacheKey() -> String
}
