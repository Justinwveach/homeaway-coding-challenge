//
//  Pagination.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/8/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation


/// This protocol can be implemented if data needs to be paginated.
protocol Pagination {
    
    func isPageable() -> Bool
    func getCurrentPage() -> Int
    func getPageSize() -> Int
    func getTotalItems() -> Int
    func getSearchString() -> String
    
}
