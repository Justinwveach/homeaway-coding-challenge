//
//  Event.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import ObjectMapper

// Documentation: http://platform.seatgeek.com/#events
struct Event: Mappable, SearchResult {
    
    // According to seatgeek documentation, id and performers are optional
    var id: Int?
    var title = ""
    var date: Date!
    var venue: Venue!
    var performers: [Performer]?
    
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
    
    init?(map: Map) {
        
    }

    init(title: String) {
        self.title = title
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
    
    
    
}

/*
private func extractDate(object: Any?) throws -> Date {
    guard let dateAsString = object as? String else {
        throw MapperError.convertibleError(value: object, type: String.self)
    }
    
    let dateFor: DateFormatter = DateFormatter()
    dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss:SSS"
    
    if let convertedDate = dateFor.date(from: dateAsString) {
        return convertedDate
    }
    
    throw MapperError.customError(field: nil, message: "Couldn't split the string!")
}
*/


