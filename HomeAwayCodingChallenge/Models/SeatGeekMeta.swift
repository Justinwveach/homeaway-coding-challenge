//
//  SeatGeekMeta.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/8/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import ObjectMapper

struct SeatGeekMeta: Mappable {
    
    var perPage: Int = 0
    var page: Int = 0
    var total: Int = 0
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        perPage <- map["per_page"]
        page <- map["page"]
        total <- map["total"]
    }
    
}
