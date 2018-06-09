//
//  SearchResults.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import IGListKit

class SearchResults: NSObject, ListDiffable {
    
    var results: BaseSearchResult
    var header = ""
    var type: SearchResultType
    
    init(results: SeatGeekResults, header: String, type: SearchResultType) {
        self.results = results
        self.header = header
        self.type = type
    }
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
    
    func remainingItems() -> Int {
        if results.isPageable() {
            return results.getTotalItems() - results.getItems().count
        }
        return 0
    }
    
}
