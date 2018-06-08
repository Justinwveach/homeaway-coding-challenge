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
    
    var items = [SearchResult]()
    var header = ""
    
    init(results: [SearchResult], header: String) {
        self.items = results
        self.header = header
    }
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
    
}
