//
//  Venuee.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import ObjectMapper

struct Venue: Mappable, SearchResult {
    
    // According to seatgeek documentation (http://platform.seatgeek.com/#venues), all of these fields are optional with a default value of null
    var id: Int?
    var city: String?
    var name: String?
    var state: String?
    var country: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        city <- map["city"]
        name <- map["name"]
        state <- map["state"]
        country <- map["country"]
    }
    
    // MARK: - Search Result Delegate

    func getUniqueId() -> String {
        return "VENUE-\(id ?? 0)"
    }
    
    func getTitle() -> String {
        return name ?? "N/A"
    }
    
    func getThirdInfo() -> String {
        if let city = city,
           let state = state {
            return "(\(city), \(state)"
        }
        return "Location Unknown"
    }
    
    // todo: Add other venue properties if needed
    
    /*
    init(map: Mapper) throws {
        id = map.optionalFrom("id")
        city = map.optionalFrom("city")
        name = map.optionalFrom("name")
        state = map.optionalFrom("state")
        country = map.optionalFrom("country")
    }
    */
}
