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
    var offset: Int { get }
    var limit: Int { get }
    func fetchPokemons() async throws -> [Pokemon]
}


// MARK: - PokemonListInteractor

final class PokemonListInteractor {
    
    weak var presenter: PokemonListPresenterType?

    var offset = 0
    let limit = 20
}

// MARK: - PokemonListInteractorType implementation

extension PokemonListInteractor: PokemonListInteractorType {

    func fetchPokemons() async throws -> [Pokemon] {
                
        let pokemons = try await PokemonManager.shared.fetchPokemons(offset: self.limit, limit: self.offset)
        
        self.offset += pokemons.count
        return pokemons
    }
}
