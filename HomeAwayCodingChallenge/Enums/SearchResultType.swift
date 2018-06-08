//
//  SearchResultType.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation

protocol SearchType {
    
}

enum SearchResultType: String, SearchType {
    
    case event = "events"
    case venue = "venues"
    case performer = "performers"
    
}
