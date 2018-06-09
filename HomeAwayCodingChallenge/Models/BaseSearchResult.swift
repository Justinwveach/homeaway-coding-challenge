//
//  BaseSearchResult.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/8/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation

// In an attempt to keep certain closures arguments generic (e.g. provide BaseSearchResult instead of SeatGeekResults). Closures were unable to infer the type of T where T = Pagination and ResultList. This is my attempt at keeping things generic.
class BaseSearchResult: Pagination, ResultList {
    
    var searchString = ""

    func getCurrentPage() -> Int {
        preconditionFailure("Method should be implemented in subclass.")
    }
    
    func getPageSize() -> Int {
        preconditionFailure("Method should be implemented in subclass.")
    }
    
    func getTotalItems() -> Int {
        preconditionFailure("Method should be implemented in subclass.")
    }
    
    func isPageable() -> Bool {
        return false
    }
    
    func getItems() -> [SearchResult] {
        preconditionFailure("Method should be implemented in subclass.")
    }
    
    func removeAllItems() {
        preconditionFailure("Method should be implemented in subclass.")
    }
    
    func getSearchString() -> String {
        preconditionFailure("Method should be implemented in subclass.")
    }
    
    func append(items: [SearchResult]) {
        preconditionFailure("Method should be implemented in subclass.")
    }
    
}

