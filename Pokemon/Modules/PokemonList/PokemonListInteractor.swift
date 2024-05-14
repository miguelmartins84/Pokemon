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
    
    func fetchInitialPokemons() async throws -> [Pokemon]
    func fetchNextPokemons() async throws -> [Pokemon]
    func fetchPokemons(withNamesStartingWith searchText: String) async throws -> [Pokemon]
    func didSetFavoriteStatus(for pokemonViewModel: PokemonViewModel) async throws
    func storeFavoriteStatus(for pokemonViewModel: PokemonViewModel)
}

// MARK: - PokemonListInteractor

final class PokemonListInteractor {
    
    weak var presenter: PokemonListPresenterType?
    
    private var pokemonManager: PokemonManagerType    
    
    init(pokemonManager: PokemonManagerType = PokemonManager.shared) {
        
        self.pokemonManager = pokemonManager
    }
}

// MARK: - PokemonListInteractorType implementation

extension PokemonListInteractor: PokemonListInteractorType {
    
    func fetchInitialPokemons() async throws -> [Pokemon] {
        
        return try await self.pokemonManager.fetchInitialPokemons()

    }
    
    func fetchNextPokemons() async throws -> [Pokemon] {
        
        return try await self.pokemonManager.fetchPokemons()
    }
    
    func fetchPokemons(withNamesStartingWith searchText: String) async throws -> [Pokemon] {
        
        return try await self.pokemonManager.fetchPokemons(withNamesStartingWith: searchText)
    }
    
    func didSetFavoriteStatus(for pokemonViewModel: PokemonViewModel) async throws {
        
        do {
            
            try await self.pokemonManager.didChangePokemonFavoriteStatus(with: pokemonViewModel.id, pokemonName: pokemonViewModel.name, isFavorite: !pokemonViewModel.isFavorited)
            
        } catch {
            
            throw PokemonNetworkError.failedToAddPokemon(with: error)
        }
    }
    
    func storeFavoriteStatus(for pokemonViewModel: PokemonViewModel) {
        
        self.pokemonManager.didStoreFavoriteStatus(with: pokemonViewModel.id, pokemonName: pokemonViewModel.name, isFavorite: !pokemonViewModel.isFavorited)
    }
}
