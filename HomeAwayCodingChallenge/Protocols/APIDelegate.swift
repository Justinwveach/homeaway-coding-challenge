//
//  APIDelegate.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation

protocol SearchAPIDelegate {
    
    func queryItems<T>(with string: String) -> [T]
    
}
