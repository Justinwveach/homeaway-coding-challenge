//
//  Venuee.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import ObjectMapper


/// This model represents a Venue that is returned from the Seat Geek API. Documentation can be found at http://platform.seatgeek.com/#venues
struct Venue: Mappable, SearchResult {
    
    // According to seatgeek documentation, all of these fields are optional with a default value of null
    var id: Int?
    var city: String?
    var name: String?
    var state: String?
    var country: String?
    
    // MARK: - Mappable
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        city <- map["city"]
        name <- map["name"]
        state <- map["state"]
        country <- map["country"]
    }
    
    // MARK: - SearchResult

    func getUniqueId() -> String {
        return "VENUE-\(id ?? 0)"
    }
    
    func getTitle() -> String {
        return name ?? "N/A"
    }
    
    func getSecondaryInfo() -> String {
        if let city = city,
           let state = state {
            return "\(city), \(state)"
        }
        return "Location Unknown"
    }
    
}
