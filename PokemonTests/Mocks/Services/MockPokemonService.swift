//
//  MockPokemonService.swift
//  PokemonTests
//
//  Created by Miguel Martins on 14/05/2024.
//

import Foundation
@testable import Pokemon

enum MockPokemonServiceError: Error {
    
    case noPokemonFound
}

class MockPokemonService: PokemonServiceType {
    
    var pokemonModels: [PokemonModel] = []
    var pokemons: [Pokemon] = []
    var favoritePokemons: [FavoritePokemonDataModel] = []
    
    init(pokemonModels: [PokemonModel] = [],
         pokemons: [Pokemon] = [],
         favoritePokemons: [FavoritePokemonDataModel] = []
    ) {
        
        self.pokemonModels = pokemonModels
        self.pokemons = pokemons
        self.favoritePokemons = favoritePokemons
    }
    
    func fetchAllPokemonModels() async throws -> [PokemonModel] {
        
        return self.pokemonModels
    }
    
    func fetchPokemons(from pokemonModels: [PokemonModel]) async throws -> [Pokemon] {
        
        return self.pokemons
    }
    
    func fetchPokemon(for pokemonName: String) async throws -> Pokemon {
        
        guard let pokemon = self.pokemons.first(where: { $0.name == pokemonName }) else {
            
            throw MockPokemonServiceError.noPokemonFound
        }
        
        return pokemon
    }
    
    func addPokemonToFavorites(with pokemonId: Int, pokemonName: String) async throws -> Bool {
                
        let favoritePokemon = FavoritePokemonDataModel(id: pokemonId, name: pokemonName)
        self.favoritePokemons.append(favoritePokemon)
        
        return true
    }
    
    func removePokemonFromFavorites(with pokemonId: Int, pokemonName: String) async throws -> Bool {
        
        guard let favoritePokemonIndex = self.favoritePokemons.firstIndex(where: { $0.id == pokemonId }) else {
            
            throw MockPokemonServiceError.noPokemonFound
        }
        
        let _ = self.favoritePokemons.remove(at: favoritePokemonIndex)
        
        return false
    }
    
    func appendPokemonModels(with pokemonModels: [PokemonModel]) {
        
        self.pokemonModels.append(contentsOf: pokemonModels)
    }
    
    func appendPokemons(with pokemons: [Pokemon]) {
        
        self.pokemons.append(contentsOf: pokemons)
    }
}
