//
//  LoadItemsDelegate.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/9/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation


/// A class can implement this protocol to receive a notification that the user wants to load more items for a data set.
protocol LoadItemsDelegate {
    
    func loadMoreItems(for section: SectionData)
    
}
