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
    
    var favoritePokemons: Set<Int> = []
    
    var delegate: PokemonManagerDelegateType?
    var shouldThrowError: Bool
    
    init(favoritePokemons: Set<Int> = [],
         delegate: PokemonManagerDelegateType? = nil,
         shouldThrowError: Bool = false
    ) {
        
        self.favoritePokemons = favoritePokemons
        self.delegate = delegate
        self.shouldThrowError = shouldThrowError
    }
    
    func fetchInitialPokemons() async throws -> [Pokemon] {
        
        return []
    }
    
    func fetchPokemons() async throws -> [Pokemon] {
        
        return []
    }
    
    func fetchPokemons(withNamesStartingWith searchText: String) async throws -> [Pokemon] {
        
        return []
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
