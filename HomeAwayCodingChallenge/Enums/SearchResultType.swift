//
//  SearchResultType.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation


/// Indicates the type of search that was performed against the Seat Geek API.
///
/// - event: The json key for events.
/// - venue: The json key for venues.
/// - performer: The json key for performers.
/// - meta: The json key for metadata.
enum SearchResultType: String {
    
    case event = "events"
    case venue = "venues"
    case performer = "performers"
    case meta = "meta"
    
    
    /// Returns the order in which to display the sections.
    ///
    /// - Returns: The order of this type.
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
