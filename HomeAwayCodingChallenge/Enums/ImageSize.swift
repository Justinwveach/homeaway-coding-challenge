//
//  ImageSize.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation


/// Indicates the value used as a key in the json returned from Seat Geek API.
///
/// - small: Key for small image.
/// - medium: Key for medium image.
/// - large: Key for large i,age.
/// - huge: Key for huge image.
enum ImageSize: String {
    
    case small = "small"
    case medium = "medium"
    case large = "large"
    case huge = "huge"
    
}
