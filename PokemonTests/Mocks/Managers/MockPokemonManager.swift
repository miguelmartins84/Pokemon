//
//  MockPokemonManager.swift
//  PokemonTests
//
//  Created by Miguel Martins on 15/05/2024.
//

import Foundation
@testable import Pokemon

enum MockPokemonManagerError: Error {
    
    case error(message: String)
}

class MockPokemonManager: PokemonManagerType {
    
    var allPokemonModels: [PokemonModel]
    var refinedPokemonModels: [PokemonModel]
    var allFetchedPokemons: [Pokemon]
    
    var refinedPokemons: [Pokemon]
    var favoritePokemons: Set<Int> = []
    
    var delegate: PokemonManagerDelegateType?
    var shouldThrowError: Bool
    
    var isInSearchContext: Bool
    
    init(favoritePokemons: Set<Int> = [],
         allPokemonModels: [PokemonModel] = [],
         refinedPokemonModels: [PokemonModel] = [],
         allFetchedPokemons: [Pokemon] = [],
         refinedPokemons: [Pokemon] = [],
         delegate: PokemonManagerDelegateType? = nil,
         isInSearchContext: Bool = false,
         shouldThrowError: Bool = false
    ) {
        
        self.allPokemonModels = allPokemonModels
        self.refinedPokemonModels = refinedPokemonModels
        self.allFetchedPokemons = allFetchedPokemons
        self.refinedPokemons = refinedPokemons
        self.favoritePokemons = favoritePokemons
        self.delegate = delegate
        self.isInSearchContext = isInSearchContext
        self.shouldThrowError = shouldThrowError
    }
    
    func fetchInitialPokemons() async throws -> [Pokemon] {
        
        return self.isInSearchContext ? self.refinedPokemons : self.allFetchedPokemons
    }
    
    func fetchPokemons() async throws -> [Pokemon] {
        
        return self.isInSearchContext ? self.refinedPokemons : self.allFetchedPokemons
    }
    
    func fetchPokemons(withNamesStartingWith searchText: String) async throws -> [Pokemon] {
        
        return self.isInSearchContext ? self.refinedPokemons.filter({ $0.name.hasPrefix(searchText) }) : self.allFetchedPokemons.filter({ $0.name.hasPrefix(searchText) })
    }
    
    func didChangePokemonFavoriteStatus(with pokemonId: Int, pokemonName: String, isFavorite: Bool) async throws -> Bool {
        
        guard shouldThrowError == false else {
            
            throw MockPokemonManagerError.error(message: "Failed to change pokemon favorite status")
        }
        
        if self.favoritePokemons.contains(pokemonId) {
            
            self.favoritePokemons.remove(pokemonId)
            return false
            
        } else {
            
            self.favoritePokemons.insert(pokemonId)
            return true
        }
    }
    
    func fetchFavoriteStatus(for pokemonId: Int) -> Bool {
        
        self.favoritePokemons.contains(pokemonId)
    }
    
    func didStoreFavoriteStatus(with pokemonId: Int, pokemonName: String, isFavorite: Bool) {
        
        self.favoritePokemons.insert(pokemonId)
    }
}
