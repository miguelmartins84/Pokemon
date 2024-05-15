//
//  Pokemon.swift
//  PokemonTests
//
//  Created by Miguel Martins on 15/05/2024.
//

import Foundation
@testable import Pokemon

extension Pokemon {
    
    static func mock(
        id: Int = 1,
        name: String = "Pikachu",
        height: Double = 50,
        weight: Double = 50,
        types: [PokemonModelType] = [PokemonModelType(type: PokemonType(name: "fire", url: "fire"))],
        sprites: Sprites = Sprites(otherSprites: OtherSprites(officialArtwork: nil)),
        stats: [StatModel] = [StatModel(baseStat: 48, effort: 48, stat: Stat(name: "hp")),
                              StatModel(baseStat: 48, effort: 48, stat: Stat(name: "attack")),
                              StatModel(baseStat: 48, effort: 48, stat: Stat(name: "defense")),
                              StatModel(baseStat: 48, effort: 48, stat: Stat(name: "speed"))],
        defense: Double = 100,
        speed: Double = 100,
        order: Int = 1
    ) -> Pokemon {
        
        Pokemon(
            id: id,
            name: name,
            height: height,
            weight: weight,
            types: types,
            sprites: sprites,
            stats: stats,
            order: 1
        )
    }
}
