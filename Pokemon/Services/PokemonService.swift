//
//  PokemonService.swift
//  Pokemon
//
//  Created by Miguel Martins on 12/05/2024.
//

import Foundation

enum PokemonNetworkError: Error {
    
    case badURL
    case failedToAddPokemon(with: Error)
}

protocol PokemonServiceType {
    
    func fetchAllPokemonModels() async throws -> [PokemonModel]
//    func fetchPokemons(for requestType: PokemonRequestTypes) async throws -> Pokemon
    func fetchPokemons(from pokemonModels: [PokemonModel]) async throws -> [Pokemon]
    func fetchPokemon(for pokemonName: String) async throws -> Pokemon
    func addPokemonToFavorites(with pokemonId: Int, pokemonName: String) async throws -> Bool
    func removePokemonFromFavorites(with pokemonId: Int, pokemonName: String) async throws -> Bool
}

class PokemonService: PokemonServiceType {    

    func fetchAllPokemonModels() async throws -> [PokemonModel] {
        
        let requestType: PokemonRequestTypes = .allPokemonModels
        
        guard let url = requestType.urlComponents.url else {
            
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
        
        guard let url = requestType.urlComponents.url else {
            
            throw PokemonNetworkError.badURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
        return pokemon
    }
    
    func addPokemonToFavorites(with pokemonId: Int, pokemonName: String) async throws -> Bool {
        
        try await self.changeFavoriteStatus(with: pokemonId, pokemonName: pokemonName, setTo: true)
    }
    
    func removePokemonFromFavorites(with pokemonId: Int, pokemonName: String) async throws -> Bool {
        
        try await self.changeFavoriteStatus(with: pokemonId, pokemonName: pokemonName, setTo: false)
    }
    
    private func changeFavoriteStatus(with pokemonId: Int, pokemonName: String, setTo favorite: Bool) async throws -> Bool {
        
        let requestType = PokemonRequestTypes.changeFavoriteStatus(pokemonId: String(pokemonId), pokemonName: pokemonName)
        
        let urlComponents = requestType.urlComponents
        
        guard let url = urlComponents.url else {
            
            throw PokemonNetworkError.badURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = urlComponents.percentEncodedQuery?.data(using: .utf8)
        
        let (_, _) = try await URLSession.shared.data(for: urlRequest)
        
        let newStatus = favorite
        
        let logMessagePrefix = "Pokemon with name \(pokemonName)"
        let logMessageSufix = newStatus ? "added to favorites successfully!": "removed from favorites successfully!"
        
        print("\(logMessagePrefix) \(logMessageSufix)")
        
        return newStatus
    }
}
