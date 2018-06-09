//
//  Event.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import ObjectMapper


/// This model represents an Event that is retrieved from the Seat Geek APIs. Documentation can be found at http://platform.seatgeek.com/#events
struct Event: Mappable, SearchResult {
    
    // According to seatgeek documentation, id and performers are optional
    var id: Int?
    var title = ""
    var date: Date!
    var venue: Venue!
    var performers: [Performer]?
    
    init(title: String, date: Date) {
        self.title = title
        self.date = date
    }
    
    // MARK: - Mappable
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        venue <- map["venue"]
        performers <- map["performers"]
        
        let dateFor: DateFormatter = DateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let transform = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
            // transform value from String? to Date?
            if let convertedDate = dateFor.date(from: value!) {
                return convertedDate
            }
            
            return nil
        }, toJSON: { (value: Date?) -> String? in
            // transform value from Date? to String?
            if let value = value {
                return String(dateFor.string(from: value))
            }
            return nil
        })
        
        
        date <- (map["datetime_local"], transform)
    }
    
    // MARK: - SearchResult
    
    func getUniqueId() -> String {
        return "EVENT-\(id ?? 0)"
    }
    
    func getTitle() -> String {
        return !title.isEmpty ? title : "N/A"
    }
    
    func getSecondaryInfo() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy h:mm a"
        return dateFormatter.string(from: date)
    }
    
    func getThirdInfo() -> String {
        if let venue = venue {
            if let city = venue.city,
               let state = venue.state {
                return "\(city), \(state)"
            }
        }
        return "Location Unknown"
    }
    
    func getThumbnailUrl() -> URL? {
        if let primaryPerformer = getPrimaryPerformer() {
            return primaryPerformer.getThumbnailUrl()
        }
        
        return nil
    }
    
    func getMainImageUrl() -> URL? {
        if let primaryPerformer = getPrimaryPerformer() {
            return primaryPerformer.getMainImageUrl()
        }
        
        return nil
    }
    
    // MARK: - Private Methods
    
    
    /// An event may contain 0 or more performers. This will check to see if the event has a primary performer and return it if so.
    ///
    /// - Returns: The primary performer.
    fileprivate func getPrimaryPerformer() -> Performer? {
        guard let performers = performers else {
            return nil
        }
        
        if performers.count > 0 {
            for performer in performers {
                if performer.primary {
                    return performer
                }
            }
        }
        
        return nil
    }
    
}


