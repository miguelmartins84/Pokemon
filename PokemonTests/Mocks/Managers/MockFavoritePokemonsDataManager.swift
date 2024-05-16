//
//  MockFavoritePokemonsDataManager.swift
//  PokemonTests
//
//  Created by Miguel Martins on 14/05/2024.
//

@testable import Pokemon

class MockFavoritePokemonsDataManager: FavoritePokemonsDataManagerType {
    
    var favoritePokemons: [FavoritePokemonDataModel]
    
    init(favoritePokemons: [FavoritePokemonDataModel] = []) {
        
        self.favoritePokemons = favoritePokemons
    }
    
    func getFavorites() -> [FavoritePokemonDataModel] {

        return favoritePokemons
    }
    
    func addToFavorites(favoritePokemonDataModel: FavoritePokemonDataModel) {

        self.favoritePokemons.append(favoritePokemonDataModel)
    }
    
    func removeFromFavorites(favoritePokemonDataModel: FavoritePokemonDataModel) {
        
        if let pokemonIndex = self.favoritePokemons.firstIndex(where: { $0.id == favoritePokemonDataModel.id }) {
            
            self.favoritePokemons.remove(at: pokemonIndex)
        }
    }
}
