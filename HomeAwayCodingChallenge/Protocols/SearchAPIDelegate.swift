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


/// An API class can implement this protocol to query items based on given url params/search text.
protocol SearchAPIDelegate {
    
    
    /// Queries items for a given string with additional url parameters.
    ///
    /// - Parameters:
    ///   - string: The string that was searched for.
    ///   - params: Additional url parameters, if needed.
    ///   - completion: Closure to be called with the resulting details.
    /// - Returns: Nothing
    func queryItems<T: ResultList & Pagination>(with string: String, params: [URLQueryItem], completion: (@escaping (T) -> Void))
        
    func cacheKey() -> String
    
}
