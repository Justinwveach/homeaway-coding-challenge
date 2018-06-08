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
    
    var perPage: Int?
    var page: Int?
    var total: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        perPage <- map["per_page"]
        page <- map["page"]
        total <- map["total"]
    }
    
}
