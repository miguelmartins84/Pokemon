//
//  PokemonService.swift
//  Pokemon
//
//  Created by Miguel Martins on 12/05/2024.
//

import Foundation

enum PokemonNetworkError: Error {
    
    case badURL
}

protocol PokemonServiceType {
    
    func fetchAllPokemonModels() async throws -> [PokemonModel]
//    func fetchPokemons(for requestType: PokemonRequestTypes) async throws -> Pokemon
    func fetchPokemons(from pokemonModels: [PokemonModel]) async throws -> [Pokemon]
    func fetchPokemon(for pokemonName: String) async throws -> Pokemon
}

class PokemonService: PokemonServiceType {

    func fetchAllPokemonModels() async throws -> [PokemonModel] {
        
        let requestType: PokemonRequestTypes = .allPokemonModels
        
        guard let url = requestType.url else {
            
            throw PokemonNetworkError.badURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let pokemonResults = try JSONDecoder().decode(PokemonResults.self, from: data)

        let pokemonModels = pokemonResults.results.sorted {
            
            $0.name < $1.name
        }
        
        return pokemonModels
    }
    

    func fetchPokemons(from pokemonModels: [PokemonModel]) async throws -> [Pokemon] {
        
        return try await withThrowingTaskGroup(of: Pokemon.self) { group in
            
            for pokemonModel in pokemonModels {
                
                group.addTask {
                    
                    let pokemon = try await self.fetchPokemon(for: pokemonModel.name)
                    return pokemon
                }
            }
            
            var pokemons: [Pokemon] = []
            
            for try await fetchedPokemon in group {

                pokemons.append(fetchedPokemon)
            }
            
            return pokemons
        }
    }
    
    func fetchPokemon(for pokemonName: String) async throws -> Pokemon {
        
        let requestType = PokemonRequestTypes.pokemon(name: pokemonName)
        
        guard let url = requestType.url else {
            
            throw PokemonNetworkError.badURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
        return pokemon
    }
}
