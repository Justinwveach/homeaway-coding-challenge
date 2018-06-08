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

class SeatGeekAPI: BaseAPI, SearchAPIDelegate {

    var type: SearchResultType
    
    init(baseURL: String, type: SearchResultType) {
        self.type = type
        super.init(baseURL: baseURL)
    }
    
    func call(urlParams: [String: String], completion: @escaping (([Mappable]) -> Void)) {
        let url = urlWith(baseUrl: baseURL, params: urlParams)
        call(url: url, completion: completion)
    }
    
    // MARK: - Search API Delegate
    
    func mapObject(from json: String) -> Mappable? {
        if json.isEmpty {
            return nil
        }
        
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
        }
        
        return nil
    }
    
    // Protocol method that queries based on a string. Any API class could implement this delegate and provide results based on search text.
    func queryItems(with string: String, completion: @escaping (([Mappable]) -> Void)) {
        let queryString = string.replacingOccurrences(of: " ", with: "+")
        
        // Add any other params that are desired for a typical search query (i.e. per_page=25&page=3)
        let url = "\(baseURL)&per_page=10&q=\(queryString)"
        
        call(url: url, completion: completion)
    }
    
    func cacheKey() -> String {
        return type.rawValue
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func call(url: String, completion: @escaping (([Mappable]) -> Void)) {
        Alamofire.request(url).responseJSON { [weak self] response in
            guard let strongSelf = self else {
                return
            }
            
            guard let jsonString = response.result.value else {
                return
            }
            
            let json = JSON(jsonString)
            
            guard let dictionary = json.dictionary else {
                return
            }
            
            guard let array = dictionary[strongSelf.type.rawValue]?.array else {
                return
            }
            
            var results = [Mappable]()
            
            for jsonObject in array {
                guard let jsonString = jsonObject.rawString() else {
                    continue
                }
                
                if let object = strongSelf.mapObject(from: jsonString) {
                    results.append(object)
                }
            }
            
            completion(results)
        }
    }
    
    fileprivate func urlWith(baseUrl: String, params: [String: String]) -> String {
        // todo: The base url contains a client id as our first parameter. In the future, we should add parameters more dynamically in case the base url doesnt contain a parameter. That is, to make sure we use a & and not a ? in the url.
        var newUrlString = baseURL
        for (urlParam, value) in params {
            newUrlString = "\(newUrlString)&\(urlParam)=\(value)"
        }
        return newUrlString
    }
    
    /*
    // URL example
    // https://api.seatgeek.com/2/events?client_id=<your client id>&q=Texas+Ranger
    func queryItems<T: SearchResult>(by types: [SearchResultType], string: String, completion: (([T]) -> Void)) {
        for type in types {
            guard let url = createUrl(type: type, string: string) else {
                continue
            }
        }
        
        // ensure
        Alamofire.request(url).responseArray { (response: DataResponse<[Event]>) in
            let statusCode = response.response?.statusCode
            let results = response.result.value
            if let results = results {
                for result in results {
                    
                }
            }
        }
    }
    
    func queryEvents(string: String) {
        Alamofire.request(url).responseArray { (response: DataResponse<[Event]>) in
            let statusCode = response.response?.statusCode
            let results = response.result.value
            if let results = results {
                for result in results {
                    
                }
            }
        }
    }
    
    func createUrl(type: SearchResultType, string: String) -> String? {
        if !seatgeekApiUrl.isEmpty && !seatgeekClientId.isEmpty && !string.isEmpty {
            return "\(seatgeekApiUrl)\(type.rawValue)?client_id=\(seatgeekClientId)&q=\(string)"
        }
        return nil
    }
    */
    
   
    
//    func submit(request: URLRequest, handler: HttpResponseHandler?) {
//        if !Connectivity.isConnectedToInternet() {
//            handler?.onFailure(JSON("No internet connection."))
//            return
//        }
//
//        Alamofire.request(request).responseJSON { response in
//            let statusCode = response.response?.statusCode
//            let json = JSON(response.result.value!)
//            if statusCode == 200 {
//                handler?.onSuccess(json)
//            } else {
//                handler?.onFailure(json)
//                DDLogDebug("Unable to fetch.")
//            }
//        }
//    }
}
