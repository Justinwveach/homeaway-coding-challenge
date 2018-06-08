//
//  TypeAheadSearch.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import UIKit
import ObjectMapper


/// This class handles search functionality for a search bar. APIs that implement the SearchAPIDelegate protocol can be added to this class. If a search result isn't found in the cache, it will call the APIs and return the results as [Mappable]. With this, you can search against multiple APIs based on one search text. For our purposes, we are searching against the SeatGeekAPI which consists of 3 separate APIs.
class TypeAheadSearch: NSObject, UISearchBarDelegate {
    
    var apis = [String: SearchAPIDelegate]()
    var cache = [String: [String: [Mappable]]]()
    weak var delegate: TypeAheadSearchDelegate?
    
    override init() {
        #if DEBUG
        // Create a cache that can be used for testing
        #endif
    }
    func add(api: SearchAPIDelegate) {
        apis[api.cacheKey()] = api
        //cache[api.cacheKey()] = [String: [SearchResult]]()
    }
        
    fileprivate func callApis(string: String) {
        for (key, api) in apis {
            api.queryItems(with: string) { [weak self] results in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.cacheSearch(cacheKey: key, searchString: string, results: results)
                strongSelf.delegate?.queried(items: results)
            }
        }
    }
    
    fileprivate func cacheSearch(cacheKey: String, searchString: String, results: [Mappable]) {
        cache[cacheKey] = [searchString: results]
    }
    
    // MARK: - Search Bar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 2 {
            
            // todo: check cache
            callApis(string: searchText)
        } else {
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    fileprivate func clearSearch() {
        
    }
    
}
