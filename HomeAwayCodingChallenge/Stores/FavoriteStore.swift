//
//  FavoriteStore.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/8/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import RealmSwift

struct FavoriteStore {
    
    static let shared = FavoriteStore()
    
    func checkFavorite(id: String, completion: (Bool) -> Void) {
        let realm = try! Realm()
        if let favoriteItem = realm.objects(Favorite.self).filter("id == %@", id).first {
            completion(favoriteItem.favorited)
        } else {
            completion(false)
        }
    }
    
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
