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
}

// MARK: - PokemonInteractor

final class PokemonDetailInteractor {
    
    weak var presenter: PokemonDetailPresenterType?
    
    private(set) var pokemon: PokemonViewModel
    
    // MARK: - Initializer
    init(pokemon: PokemonViewModel) {

        self.pokemon = pokemon
    }
}

// MARK: - PokemonInteractorType implementation

extension PokemonDetailInteractor: PokemonDetailInteractorType {}
