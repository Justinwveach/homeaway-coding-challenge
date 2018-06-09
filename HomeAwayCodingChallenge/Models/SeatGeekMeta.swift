//
//  SeatGeekMeta.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/8/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import ObjectMapper


/// This model represents the metadata that is returned for each Seat Geek API call.
struct SeatGeekMeta: Mappable {
    
    // Items returned per page
    var perPage: Int = 0
    // Current page that was returned
    var page: Int = 0
    // Total number of items
    var total: Int = 0
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        perPage <- map["per_page"]
        page <- map["page"]
        total <- map["total"]
    }
    
}
