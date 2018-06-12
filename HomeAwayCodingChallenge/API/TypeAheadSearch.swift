//
//  TypeAheadSearch.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import UIKit
import ObjectMapper


/// This class handles search functionality for a search bar. APIs that implement the SearchAPIDelegate protocol can be added to this class. With this, you can search against multiple APIs based on one search text. For our purposes, we are searching against the SeatGeekAPI which consists of 3 separate APIs.
class TypeAheadSearch: NSObject, UISearchBarDelegate {
    // Considerations: An API may not necessarily be returned in the order it was called. For example, we may receive our results for "Texa" after "Texas". Therefore, our delegate would receive a result set for "Texa" last when they should be presenting "Texas". Might be up to the delegate to do this check and handle appropriately.
    
    /// APIs (must implement SearchAPIDelgate) that the type ahead will search against when the user enters in characters
    var apis = [SearchAPIDelegate]()
    
    // todo: implement cache that will return a result set if it has already been searched. Invalidate the cache after a certain amount of time (set in .xcconfig file)
    var cache = [String: [String: [Mappable]]]()
    
    // Our delegate will receive notifications when we have found new data or if the search is canceled
    weak var delegate: TypeAheadSearchDelegate?
    
    override init() {
        #if DEBUG
        // Create a cache that can be used for testing
        #endif
    }
    
    // MARK: - Public Methods
    
    /// Inject our API dependencies. Whenever a search needs to be performed, we will call all apis.
    ///
    /// - Parameter api: API that will handle the search based on text. Must implement SearchAPIDelegate.
    func add(api: SearchAPIDelegate) {
        apis.append(api)
        //cache[api.cacheKey()] = [String: [SearchResult]]()
    }
    
    /// Method that can be used manually instead of relying on search bar.
    ///
    /// - Parameter text: Text to search.
    func search(text: String) {
        callApis(string: text)
    }
    
    // MARK: - Private Methods
    
    /// Calls APIs that will handle the search.
    ///
    /// - Parameter string: The text to be searched.
    fileprivate func callApis(string: String) {
        for api in apis {
            api.queryItems(with: string, params: []) { [weak self] (results: BaseSearchResult) in
                guard let strongSelf = self else {
                    return
                }
                results.searchString = string
                //strongSelf.cacheSearch(cacheKey: key, searchString: string, results: results)
                strongSelf.delegate?.queried(results: results)
            }
        }
    }
    
    // todo: implement cache functionality
    fileprivate func cacheSearch(cacheKey: String, searchString: String, results: [Mappable]) {
    }
    
    // MARK: - Search Bar Delegate
    
    // todo: Right now, our view controllers just assign the UISearchBarDelegate to TypeAheadSearch. In the future, we probably want this search to work with any textfield and not just a SearchBar.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 2 {
            // todo: check cache. If a valid set exists, return that instead of calling apis.
            callApis(string: searchText)
        } else if searchText.count == 0 {
            delegate?.canceledSearch()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        delegate?.canceledSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
