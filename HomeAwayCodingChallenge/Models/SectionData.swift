//
//  SearchResults.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import IGListKit


/// This model represents a section for SeatGeekResults that will be displayed on the collection view. For example, we will have an event section, a performer section, and a venue section. Each section contains the results, a header, and any other information needed.
class SectionData: NSObject, ListDiffable {
    
    var results: BaseSearchResult
    // Describes the section (i.e. Events)
    var header = ""
    var type: SearchResultType
    
    init(results: SeatGeekResults, header: String, type: SearchResultType) {
        self.results = results
        self.header = header
        self.type = type
    }
    
    
    /// Calculates the remaining number of items if this section contains pageable data.
    ///
    /// - Returns: The number of remaining items or 0 if not pageable.
    func remainingItems() -> Int {
        if results.isPageable() {
            return results.getTotalItems() - results.getItems().count
        }
        return 0
    }
    
    // MARK: - ListDiffable
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
    
}
