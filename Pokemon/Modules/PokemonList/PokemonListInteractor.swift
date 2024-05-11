//
//  PokemonListInteractor.swift
//  Marvel
//
//  Created by Miguel Martins on 04/05/2024.
//

import Foundation

// MARK: - PokemonListInteractorType

protocol PokemonListInteractorType {
    
    var presenter: PokemonListPresenterType? { get set }
    func fetchAllPokemonsModels() async throws
    func fetchNextPokemons() async throws -> [Pokemon]
    func fetchPokemons(withNamesStartingWith searchText: String) async throws -> [Pokemon]
}

// MARK: - PokemonListInteractor

final class PokemonListInteractor {
    
    weak var presenter: PokemonListPresenterType?
}

// MARK: - PokemonListInteractorType implementation

extension PokemonListInteractor: PokemonListInteractorType {
    
    func fetchAllPokemonsModels() async throws {
        
        try await PokemonManager.shared.fetchAllPokemonsModels()
    }
    
    func fetchNextPokemons() async throws -> [Pokemon] {
        
        return try await PokemonManager.shared.fetchNextPokemons()
    }
    
    func fetchPokemons(withNamesStartingWith searchText: String) async throws -> [Pokemon] {
        
        return try await PokemonManager.shared.fetchPokemons(withNamesStartingWith: searchText)
    }
}
