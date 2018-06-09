//
//  FavoriteStore.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/8/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import RealmSwift


/// This class handles the favoriting of objects (persistent). It stores the id of the object and a bool indicating if it is favorited.
/// Note: id should be unique across all objects, so it is expected that the id is in the format of "<ClassName>-<ID>"
struct FavoriteStore {
    
    static let shared = FavoriteStore()
    
    
    /// Check the store to see if an object has been favorited.
    ///
    /// - Parameters:
    ///   - id: Id of the object to check.
    ///   - completion: Closure called with bool indicating if it's favorited.
    func checkFavorite(id: String, completion: (Bool) -> Void) {
        let realm = try! Realm()
        if let favoriteItem = realm.objects(Favorite.self).filter("id == %@", id).first {
            completion(favoriteItem.favorited)
        } else {
            completion(false)
        }
    }
    
    /// Stores a boolean value for the id provided.
    ///
    /// - Parameters:
    ///   - favorited: Bool indicating if favorited.
    ///   - id: Id of object.
    func toggle(favorited: Bool, for id: String) {
        let realm = try! Realm()
        if let favoriteItem = realm.objects(Favorite.self).filter("id == %@", id).first {
            try! realm.write {
                favoriteItem.favorited = favorited
            }
        } else {
            let newFavorite = Favorite()
            newFavorite.id = id
            newFavorite.favorited = favorited
            try! realm.write {
                realm.add(newFavorite)
            }
        }
    
    }
}
