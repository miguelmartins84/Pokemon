//
//  MockPokemonViewModel.swift
//  PokemonTests
//
//  Created by Miguel Martins on 15/05/2024.
//

import Foundation
@testable import Pokemon

extension PokemonViewModel {
    
    static func mock(
        id: Int = 1,
        name: String = "Pikachu",
        imageUrl: String? = nil,
        height: Double = 50,
        weight: Double = 50,
        hp: Double = 50,
        attack: Double = 100,
        defense: Double = 100,
        speed: Double = 100,
        types: [String] = ["fire"]
    ) -> PokemonViewModel {
        
        let pokemonViewModel = PokemonViewModel(
            id: id,
            imageUrl: nil, 
            name: name,
            height: height, 
            weight: weight,
            hp: hp,
            attack: attack, 
            defense: defense,
            speed: speed,
            types: types
        )
            
        return pokemonViewModel
    }
}
