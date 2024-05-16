//
//  FavoritePokemonsDataManager.swift
//  Pokemon
//
//  Created by Miguel Martins on 13/05/2024.
//

import RealmSwift

// MARK: - FavoritePokemonsDataManagerType definition

protocol FavoritePokemonsDataManagerType: AnyObject {
    
    func getFavorites() async -> [FavoritePokemonDataModel]
    func addToFavorites(favoritePokemonDataModel: FavoritePokemonDataModel) async throws
    func removeFromFavorites(favoritePokemonDataModel: FavoritePokemonDataModel) async throws
}

// MARK: - FavoritePokemonsDataManager
class FavoritePokemonsDataManager {
    
    static let shared: FavoritePokemonsDataManagerType = FavoritePokemonsDataManager()
    
    var realm: RealmActor?
    
    init() {
        
        Task { @MainActor in
            
            try await self.realm = RealmActor()
        }        
    }
}

// MARK: - FavoritePokemonsDataManagerType implementation

extension FavoritePokemonsDataManager: FavoritePokemonsDataManagerType {
    
    func getFavorites() async -> [FavoritePokemonDataModel] {
    
        guard let realm = self.realm else {
            
            return []
        }
        
        let favoritePokemons = await realm.getFavoritePokemons()
        
        return favoritePokemons
    }
    
    func addToFavorites(favoritePokemonDataModel: FavoritePokemonDataModel) async throws {
               
        try await self.realm?.createFavoritePokemon(id: favoritePokemonDataModel.id, name: favoritePokemonDataModel.name)
    }
    
    func removeFromFavorites(favoritePokemonDataModel: FavoritePokemonDataModel) async throws {
        
        guard let realm = self.realm else {
            
            return
        }
        
        try await self.realm?.deleteFavoritePokemon(with: favoritePokemonDataModel)        
    }
}
