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
    
    func onPokemonDetailInteractorDidChangeFavoriteStatus(on pokemonDetailPresenter: PokemonDetailPresenterType) async throws
    func onPokemonDetailInteractorDidStoreFavoriteStatus(on pokemonDetailPresenter: PokemonDetailPresenterType)
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

    func onPokemonDetailInteractorDidChangeFavoriteStatus(on pokemonDetailPresenter: PokemonDetailPresenterType) async throws {
        
        do {
            
            let favoriteStatus = try await self.pokemonManager.didChangePokemonFavoriteStatus(with: self.pokemon.id, pokemonName: self.pokemon.name, isFavorite: !self.pokemon.isFavorited)
            pokemon.setFavoriteStatus(isFavorited: favoriteStatus)
        } catch {
            
            throw PokemonNetworkError.failedToAddPokemon(with: error)
        }
    }
    
    func onPokemonDetailInteractorDidStoreFavoriteStatus(on pokemonDetailPresenter: any PokemonDetailPresenterType) {
        
        self.pokemonManager.didStoreFavoriteStatus(with: self.pokemon.id, pokemonName: self.pokemon.name, isFavorite: self.pokemon.isFavorited)
    }
}
