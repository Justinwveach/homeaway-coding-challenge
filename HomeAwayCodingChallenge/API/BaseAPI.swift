//
//  BaseAPI.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation

class BaseAPI {
    
    var baseURL: String
    
    /// Query Items that will be appended to every url (i.e. api_key=somekey)
    var defaultQueryItems: [URLQueryItem]
    
    init(baseURL: String, defaultQueryItems: [URLQueryItem]) {
        self.baseURL = baseURL
        self.defaultQueryItems = defaultQueryItems
    }
    
    // URL example https://api.seatgeek.com/2/events?client_id=<your client id>&<param>=<value>&<param>=<value>
    func urlWith(queryItems: [URLQueryItem]) -> URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = defaultQueryItems
        urlComponents?.queryItems?.append(contentsOf: queryItems)
        
        return urlComponents?.url ?? nil
    }
    
}
