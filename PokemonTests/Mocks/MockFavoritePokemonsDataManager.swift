//
//  MockFavoritePokemonsDataManager.swift
//  PokemonTests
//
//  Created by Miguel Martins on 14/05/2024.
//

@testable import Pokemon

class MockFavoritePokemonsDataManager: FavoritePokemonsDataManagerType {
    
    var favoritePokemons: [MockFavoritePokemonDataModel]
    
    init(favoritePokemons: [MockFavoritePokemonDataModel] = []) {
        
        self.favoritePokemons = favoritePokemons
    }
    
    func getFavorites() -> [FavoritePokemonDataModel] {
        
        let favoritePokemons: [FavoritePokemonDataModel] = self.favoritePokemons.map { favoritePokemon  in
            
            let favoritePokemonDataModel = FavoritePokemonDataModel()
            favoritePokemonDataModel.id = favoritePokemon.pokemonId
            favoritePokemonDataModel.name = favoritePokemon.pokemonName
            return favoritePokemonDataModel
        }

        return favoritePokemons
    }
    
    func addToFavorites(favoritePokemonDataModel: FavoritePokemonDataModel) {
        
        let mockFavoritePokemonDataModel = MockFavoritePokemonDataModel(pokemonId: favoritePokemonDataModel.id, pokemonName: favoritePokemonDataModel.name)
        self.favoritePokemons.append(mockFavoritePokemonDataModel)
    }
    
    func removeFromFavorites(favoritePokemonDataModel: FavoritePokemonDataModel) {
        
        if let pokemonIndex = self.favoritePokemons.firstIndex(where: { $0.pokemonId == favoritePokemonDataModel.id }) {
            
            self.favoritePokemons.remove(at: pokemonIndex)
        }
    }
}
