//
//  PokemonManager.swift
//  Pokemon
//
//  Created by Miguel Martins on 09/05/2024.
//

import Foundation

enum PokemonNetworkError: Error {
    
    case badURL
}

protocol PokemonManagerType {
    
    func fetchPokemons(offset: Int, limit: Int) async throws -> [Pokemon]
}

enum PokemonRequestTypes {
    
    case pokemons(offset: String, limit: String)
    case pokemon(name: String)
    
    var url: URL? {
        
        switch self {
            
        case .pokemons:
            
            return self.composeURL(path: "/api/v2/pokemon", queryItems: self.queryItems)
            
        case let .pokemon(name):
            
            return self.composeURL(path: "/api/v2/pokemon/\(name)")
        }
    }
    
    var queryItems: [URLQueryItem]? {
        
        switch self {
            
        case let .pokemons(offset, limit):
            
            return [
                URLQueryItem(name: "offset", value: offset),
                URLQueryItem(name: "limit", value: limit)
            ]
            
        case .pokemon:

            return nil
        }
    }
    
    private func composeURL(path: String, queryItems: [URLQueryItem]? = nil) -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "pokeapi.co"
        urlComponents.path = path
        
        if let queryItems {
            
            urlComponents.queryItems = queryItems
        }
        
        let url = urlComponents.url
        
        return url
    }
}

class PokemonManager: PokemonManagerType {
    
    static let shared: PokemonManager = PokemonManager()
    
    func fetchPokemons(offset: Int, limit: Int) async throws -> [Pokemon] {
        
        let offset = String(offset)
        let limit = String(limit)
        
        return try await self.fetchPokemons(for: .pokemons(offset: offset, limit: limit))
    }
    
    private func fetchPokemon(for requestType: PokemonRequestTypes) async throws -> Pokemon {
        
        guard case PokemonRequestTypes.pokemon = requestType,
                let url = requestType.url else {
            
            throw PokemonNetworkError.badURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
        return pokemon
    }
    
    private func fetchPokemons(for requestType: PokemonRequestTypes) async throws -> [Pokemon] {
        
        guard let url = requestType.url else {
            
            throw PokemonNetworkError.badURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)        
        
        let pokemonResults = try JSONDecoder().decode(PokemonResults.self, from: data)
        
        let pokemonModels = pokemonResults.results        
                
        return try await self.loadPokemons(from: pokemonModels)
    }
    
    func loadPokemons(from pokemonModels: [PokemonModel]) async throws -> [Pokemon] {
        
        return try await withThrowingTaskGroup(of: Pokemon.self) { group in
            
            for pokemonModel in pokemonModels {
                
                group.addTask {
                    
                    let pokemonName = pokemonModel.name
                    let pokemon = try await self.fetchPokemon(for: .pokemon(name: pokemonName))
                    return pokemon
                }
            }
            
            var pokemons: [Pokemon] = []
            
            for try await fetchedPokemon in group {

                print(fetchedPokemon)
                pokemons.append(fetchedPokemon)
            }
            
            return pokemons
        }
    }
}
