//
//  RealmActor.swift
//  Pokemon
//
//  Created by Miguel Martins on 16/05/2024.
//

import RealmSwift

enum PokemonRealmError: Error {
    
    case pokemonNotFound
}

actor RealmActor {
    
    // An implicitly-unwrapped optional is used here to let us pass `self` to
    // `Realm(actor:)` within `init`
    var realm: Realm!
    
    init() async throws {
        
        realm = try await Realm(actor: self)
    }
    
    var count: Int {
        
        realm.objects(FavoritePokemonRealmModel.self).count
    }
    
    func getFavoritePokemons() -> [FavoritePokemonDataModel]{
        
        let favoritePokemonRealmModels = self.realm.objects(FavoritePokemonRealmModel.self)
        
        let pokemonModels = favoritePokemonRealmModels.map { FavoritePokemonDataModel(id: $0.id, name: $0.name) }
        return Array(pokemonModels)
    }
    
    func createFavoritePokemon(id: Int, name: String) async throws {
        
        try await self.realm.asyncWrite {
            
            realm.create(FavoritePokemonRealmModel.self, value: [
                "_id": ObjectId.generate(),
                "name": name
            ])
        }
    }
    
    func getFavoritePokemon(for pokemonId: Int) throws -> FavoritePokemonDataModel {
        
        guard let favoritePokemonRealmModel = Array(self.realm.objects(FavoritePokemonRealmModel.self).filter("id=%@", pokemonId)).first else { throw PokemonRealmError.pokemonNotFound }
        
        let favoritePokemon = FavoritePokemonDataModel(id: favoritePokemonRealmModel.id,
                                                       name: favoritePokemonRealmModel.name)
        return favoritePokemon
    }
    
    func deleteFavoritePokemon(with favoritePokemonDataModel: FavoritePokemonDataModel) async throws {

        do {
            
            let favoritePokemons = Array(self.realm.objects(FavoritePokemonRealmModel.self).filter("id=%@",favoritePokemonDataModel.id))
            
            try await self.realm.asyncWrite {
                
                self.realm.delete(favoritePokemons)
            }
            
        } catch {
            
            print("Error storing favorite pokemon \(favoritePokemonDataModel.name): \(error.localizedDescription)")
        }
    }

    func close() {
        
        self.realm = nil
    }
    
}
