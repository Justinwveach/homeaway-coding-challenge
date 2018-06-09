//
//  LoadItemsDelegate.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/9/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation

protocol LoadItemsDelegate {
    func loadMoreItems(for results: SearchResults)
}
