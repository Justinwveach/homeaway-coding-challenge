//
//  SeatGeekAPI.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper


/// Class that calls the SeatGeekAPI
/// View documentation at http://platform.seatgeek.com/
class SeatGeekAPI: BaseAPI, SearchAPIDelegate {

    var type: SearchResultType
    
    init(baseURL: String, type: SearchResultType) {
        self.type = type
        super.init(baseURL: baseURL)
    }
    
    // MARK: - Public Methods
    
    
    /// Creates a url with the given parameters and then calls the API.
    ///
    /// - Parameters:
    ///   - urlParams: Key value pairs for the url (i.e. ["q" : "Text to search", ...]
    ///   - completion: Closure that is called with the results.
    func call(urlParams: [String: String], completion: @escaping ((SeatGeekResults) -> Void)) {
        let url = urlWith(baseUrl: baseURL, params: urlParams)
        Alamofire.request(url).responseJSON { response in
            guard let jsonString = response.result.value else {
                return
            }
            
            let json = JSON(jsonString)
            
            if let seatGeekResults = self.convert(json) {
                completion(seatGeekResults)
            }
        }
    }
    
    
    /// This API returns different obects, so we check to see what was returned and then map that data to the appropriate object.
    ///
    /// - Parameter json: Data returned from API.
    /// - Returns: Appropriate object that implements SearchResult. Nil if not successful.
    func mapObject(from json: String) -> SearchResult? {
        if json.isEmpty {
            return nil
        }
        
        // Return the appropriate mapped object based on the type provided to this API instance
        switch type {
        case .event:
            if let event = Event(JSONString: json) {
                return event
            }
            break
        case .venue:
            if let venue = Venue(JSONString: json) {
                return venue
            }
            break
        case .performer:
            if let performer = Performer(JSONString: json) {
                return performer
            }
            break
        default:
            return nil
        }
        
        return nil
    }
    
    // MARK: - Search API Delegate
    
    func queryItems<T>(with string: String, params: [String : String], completion: @escaping ((T) -> Void)) where T : Pagination, T : ResultList {
        // Append other params if provided with our search query
        var paramsWithQuery = params
        // 'q' is the url param required for a query
        paramsWithQuery["q"] = string
        let url = urlWith(baseUrl: baseURL, params: paramsWithQuery)
        
        Alamofire.request(url).responseJSON { response in
            guard let jsonString = response.result.value else {
                return
            }
            
            let json = JSON(jsonString)
            
            if let seatGeekResults = self.convert(json) {
                completion(seatGeekResults as! T)
            }
        }
    }
    
    
    /// Converts the json returned from API call to our desired object - or nil if unsuccessful.
    ///
    /// - Parameter json: Data to parse.
    /// - Returns: SeatGeekResults
    fileprivate func convert(_ json: JSON) -> SeatGeekResults? {
        guard let dictionary = json.dictionary else {
            return nil
        }
        
        // Our SeatGeekAPI instance should have type that indicates what we are looking for.
        // The expected json should be in this format.
        guard let array = dictionary[self.type.rawValue]?.array else {
            return nil
        }
        
        var results = [SearchResult]()
        
        for jsonObject in array {
            guard let jsonString = jsonObject.rawString() else {
                continue
            }
            
            // Map the json string to the appropriate object.
            if let object = self.mapObject(from: jsonString) {
                results.append(object)
            }
        }
        
        let seatGeekResults = SeatGeekResults()
        seatGeekResults.items = results
        
        // Our API calls should contain metadata about the results (i.e. page number, page size, etc.)
        if let metadata = dictionary[SearchResultType.meta.rawValue]?.rawString() {
            if let meta = SeatGeekMeta(JSONString: metadata) {
                seatGeekResults.metadata = meta
            }
        }
        
        return seatGeekResults
    }
    
    // Unique identifier that will be used to cache results
    func cacheKey() -> String {
        return type.rawValue
    }

    // URL example https://api.seatgeek.com/2/events?client_id=<your client id>&<param>=<value>&<param>=<value>
    fileprivate func urlWith(baseUrl: String, params: [String: String]) -> String {
        // todo: The base url contains a client id as our first parameter. In the future, we should add parameters more dynamically in case the base url doesnt contain a parameter. That is, to make sure we use a & and not a ? in the url.
        var newUrlString = baseURL
        
        // Append key value pairs to the url
        for (urlParam, value) in params {
            newUrlString = "\(newUrlString)&\(urlParam)=\(value)"
        }
        
        // Seat Geek APIs expects a '+' instead of a space in our search strings
        let url = newUrlString.replacingOccurrences(of: " ", with: "+")
        
        return url
    }
    
}
