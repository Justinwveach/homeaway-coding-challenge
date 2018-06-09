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
        for (_, api) in apis {
            api.queryItems(with: string, params: [:]) { [weak self] (results: BaseSearchResult) in
                guard let strongSelf = self else {
                    return
                }
                results.searchString = string
                //strongSelf.cacheSearch(cacheKey: key, searchString: string, results: results)
                strongSelf.delegate?.queried(results: results)
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
