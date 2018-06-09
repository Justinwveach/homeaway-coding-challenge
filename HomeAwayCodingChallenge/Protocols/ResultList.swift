//
//  ResultList.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/8/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation

protocol ResultList {
    
    func getItems() -> [SearchResult]
    func append(items: [SearchResult])
    func removeAllItems()
    
}
