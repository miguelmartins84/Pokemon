//
//  PokemonModel.swift
//  Pokemon
//
//  Created by Miguel Martins on 09/05/2024.
//

import Foundation

struct PokemonResults: Codable {
    
    let count: Int
    let next: String
    let previous: String?
    let results: [PokemonModel]
}

struct PokemonModel: Codable {
    
    let name: String
    let url: String
}

struct OfficialArtwork: Codable {
    
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        
        case frontDefault = "front_default"
    }
}

struct OtherSprites: Codable {
    
    let officialArtwork: OfficialArtwork
    
    enum CodingKeys: String, CodingKey {
        
        case officialArtwork = "official-artwork"
    }
}

struct Sprites: Codable {

    let otherSprites: OtherSprites
    
    enum CodingKeys: String, CodingKey  {

        case otherSprites = "other"
    }
}

struct PokemonModelType: Codable {
    
    let type: [String: String]
}

struct Pokemon: Codable {
    
    let name: String
    let weight: Int
    let types: [PokemonModelType]
    let sprites: Sprites
}
