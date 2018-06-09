//
//  SearchResult.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import IGListKit


/// Protocol that is used to retrieve details for a particular search item.
protocol SearchResult {

    func getUniqueId() -> String
    func getTitle() -> String
    func getSecondaryInfo() -> String
    func getThirdInfo() -> String
    func getThumbnailUrl() -> URL?
    func getMainImageUrl() -> URL?
    
}

// Want some of the methods to be optional
extension SearchResult {
    
    func getSecondaryInfo() -> String {
        return ""
    }
    
    func getThirdInfo() -> String {
        return ""
    }
    
    func getThumbnailUrl() -> URL? {
        return nil
    }
    
    func getMainImageUrl() -> URL? {
        return nil
    }
}
