//
//  PokemonDetailInteractor.swift
//  Pokemon
//
//  Created by Miguel Martins on 10/05/2024.
//

import Foundation

// MARK: - PokemonDetailInteractorType

protocol PokemonDetailInteractorType {
    
    var presenter: PokemonDetailPresenterType? { get set }
    var pokemon: PokemonViewModel { get }
    func changeFavoriteStatus() async throws
    func storeFavoriteStatus()
}

// MARK: - PokemonInteractor

final class PokemonDetailInteractor {
    
    weak var presenter: PokemonDetailPresenterType?
    
    private(set) var pokemon: PokemonViewModel
    private var pokemonManager: PokemonManagerType
    
    // MARK: - Initializer

    init(pokemon: PokemonViewModel,
         pokemonManager: PokemonManagerType = PokemonManager.shared) {

        self.pokemon = pokemon
        self.pokemonManager = pokemonManager
    }
}

// MARK: - PokemonInteractorType implementation

extension PokemonDetailInteractor: PokemonDetailInteractorType {

    func changeFavoriteStatus() async throws {
        
        do {
            
            let favoriteStatus = try await self.pokemonManager.didChangePokemonFavoriteStatus(with: self.pokemon.id, pokemonName: self.pokemon.name, isFavorite: !self.pokemon.isFavorited)

            
        } catch {
            
            throw PokemonNetworkError.failedToAddPokemon(with: error)
        }
    }
    
    func storeFavoriteStatus() {
        
        self.pokemonManager.didStoreFavoriteStatus(with: self.pokemon.id, pokemonName: self.pokemon.name, isFavorite: self.pokemon.isFavorited)
    }
}
