//
//  Favorite.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/8/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import RealmSwift

class Favorite: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var favorited = false
    
}
