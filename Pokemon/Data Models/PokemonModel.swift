//
//  PokemonModel.swift
//  Pokemon
//
//  Created by Miguel Martins on 09/05/2024.
//

import Foundation

struct PokemonResults: Codable {
    
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonModel]
}

struct PokemonModel: Codable, Hashable {
    
    let name: String
    let url: String
}

struct OfficialArtwork: Codable, Hashable {
    
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        
        case frontDefault = "front_default"
    }
}

struct OtherSprites: Codable, Hashable {
    
    let officialArtwork: OfficialArtwork?
    
    enum CodingKeys: String, CodingKey {
        
        case officialArtwork = "official-artwork"
    }
}

struct Sprites: Codable, Hashable {

    let otherSprites: OtherSprites
    
    enum CodingKeys: String, CodingKey  {

        case otherSprites = "other"
    }
}

struct PokemonType: Codable, Hashable {
    
    let name: String
    let url: String
}

struct PokemonModelType: Codable, Hashable {
    
    let type: PokemonType
}

struct Pokemon: Codable, Hashable {
            
    let id: Int
    let name: String
    let height: Double
    let weight: Double
    let types: [PokemonModelType]
    let sprites: Sprites
    let stats: [StatModel]
    let order: Int
}

struct Stat: Codable, Hashable {
    
    let name: String
}

struct StatModel: Codable, Hashable {
    
    let baseStat: Double
    let effort: Int
    let stat: Stat
    
    enum CodingKeys: String, CodingKey {
        
        case baseStat = "base_stat"
        case effort
        case stat
    }
}
