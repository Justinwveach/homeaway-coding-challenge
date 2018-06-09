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
    case meta = "meta"
    
    func sectionOrder() -> Int {
        switch self {
        case .event:
            return 0
        case .performer:
            return 1
        case .venue:
            return 2
        default:
            return 3
        }
    }
}
