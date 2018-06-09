//
//  Performer.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import ObjectMapper


/// This model represents a Performer that is returned from the Seat Geek API. Documentation can be found at http://platform.seatgeek.com/#performers
struct Performer: Mappable, SearchResult {
    
    // According to documentation, id is the only optional field for Performer
    var id: Int?
    var name = ""
    var image = ""
    var images = [String: String]()
    var primary = false
    
    // MARK: - Mappable
    
    init?(map: Map) {
        id <- map["id"]
        name <- map["name"]
        image <- map["image"]
        images <- map["images"]
        primary <- map["primary"]
    }
    
    mutating func mapping(map: Map) {
        
    }
    
    // MARK: - SearchResult
    
    func getUniqueId() -> String {
        return "PERFORMER-\(id ?? 0)"
    }
    
    func getTitle() -> String {
        return name
    }
    
    func getThumbnailUrl() -> URL? {
        var urlString = ""
        if images.count > 0 {
            // Let's return the thumbnail if it exists
            // Could check all images in array, but only going to check for small image
            urlString = images[ImageSize.small.rawValue] ?? ""
        }
        
        // Didn't find a thumbnail, so try using the main image
        if urlString.isEmpty {
            if !image.isEmpty {
                urlString = image
            } else {
                return nil
            }
        }
        
        if let url = URL(string: urlString) {
            return url
        }
        
        return nil
    }
    
    func getMainImageUrl() -> URL? {
        if !image.isEmpty {
            if let url = URL(string: image) {
                return url
            }
        }
        return nil
    }
    
}
