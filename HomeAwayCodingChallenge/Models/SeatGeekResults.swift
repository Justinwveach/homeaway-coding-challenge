//
//  SearchResultsList.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import IGListKit

// Inheriting protocols from base class to get around having to provide an explicit type (instead of generic <T: ResultList & Pagination>. A closure could not infer T which is why I created a base class.
class SeatGeekResults: BaseSearchResult {
    
    var items = [SearchResult]()
    var metadata: SeatGeekMeta?
    
    // MARK: - Pagination
    
    override func isPageable() -> Bool {
        // Metadata contains our pageable information
        if let meta = metadata {
            if meta.page > 0 && meta.perPage > 0 && meta.total > 0 {
                return true
            }
        }
        return false
    }
    
    override func getCurrentPage() -> Int {
        return metadata?.page ?? 0
    }
    
    override func getPageSize() -> Int {
        return metadata?.perPage ?? 0
    }
    
    override func getTotalItems() -> Int {
        return metadata?.total ?? 0
    }
    
    
    override func getSearchString() -> String {
        return searchString
    }
    
    // MARK: - ResultList
    
    override func getItems() -> [SearchResult] {
        return items
    }
    
    override func append(items: [SearchResult]) {
        self.items.append(contentsOf: items)
    }
    
    override func clear() {
        self.metadata = nil
        self.items.removeAll()
    }

}
