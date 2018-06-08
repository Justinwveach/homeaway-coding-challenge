//
//  TypeAheadSearchDelegate.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import ObjectMapper

protocol TypeAheadSearchDelegate: NSObjectProtocol {

    func queried(items: [Mappable])
    func canceledSearch()
    
}
