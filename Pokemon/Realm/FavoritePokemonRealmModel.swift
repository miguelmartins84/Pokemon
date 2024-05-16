//
//  FavoritePokemonRealmModel.swift
//  Pokemon
//
//  Created by Miguel Martins on 13/05/2024.
//

import RealmSwift

class FavoritePokemonRealmModel: Object {
    
    @objc dynamic var id: Int = 0
    @objc var name: String = ""
}
