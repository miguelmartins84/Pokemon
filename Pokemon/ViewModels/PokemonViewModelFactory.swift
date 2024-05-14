//
//  PokemonViewModelFactory.swift
//  Pokemon
//
//  Created by Miguel Martins on 11/05/2024.
//

import Foundation

struct PokemonViewModelFactory {
    
    static func createPokemonViewModel(from pokemonModel: Pokemon) -> PokemonViewModel {
        
        var Hp: Double = 0
        var attack: Double = 0
        var defense: Double = 0
        var speed: Double = 0
        
        for stat in pokemonModel.stats {
            
            let value = stat.baseStat
            
            switch stat.stat.name {
                
            case "hp":
                Hp = value
                
            case "attack":
                attack = value
                
            case "defense":
                defense = value
                
            case "speed":
                speed = value
                
            default:
                continue
            }
        }
        
        var types: [String] = []
        
        for pokemonType in pokemonModel.types {
            
            types.append(pokemonType.type.name.capitalized)
        }
        
        return PokemonViewModel(
            id: pokemonModel.id,
            imageUrl: pokemonModel.sprites.otherSprites.officialArtwork?.frontDefault,
            name: pokemonModel.name.capitalized,
            height: pokemonModel.height,
            weight: pokemonModel.weight,
            hp: Hp,
            attack: attack,
            defense: defense,
            speed: speed,
            types: types
        )
    }
}
