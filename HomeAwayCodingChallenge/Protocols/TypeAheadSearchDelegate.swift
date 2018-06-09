//
//  TypeAheadSearchDelegate.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import ObjectMapper


/// A class that implements this protocol can handle querying results based on search text.
protocol TypeAheadSearchDelegate: NSObjectProtocol {

    
    /// Notifies delegate of items found.
    ///
    /// - Parameter results: The results of the query.
    func queried<T: ResultList & Pagination>(results: T)
    
    
    /// When the search is canceled.
    func canceledSearch()
    
    // todo: potentially add a 'pagedResults' method to handle when a user loads more data. Right now, the Search controller handles it, but it may be benefical to pass it on to the delegate.
}
