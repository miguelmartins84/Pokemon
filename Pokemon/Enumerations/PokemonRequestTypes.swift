//
//  PokemonRequestTypes.swift
//  Pokemon
//
//  Created by Miguel Martins on 12/05/2024.
//

import Foundation

enum PokemonRequestTypes {
    
    case allPokemonModels
    case pokemon(name: String)
    case changeFavoriteStatus(pokemonId: String, pokemonName: String)
    
    var queryItems: [URLQueryItem]? {
        
        switch self {
            
        case .allPokemonModels:
            
            return [
                URLQueryItem(name: "offset", value: "0"),
                URLQueryItem(name: "limit", value: "100000")
            ]
            
        case .pokemon:

            return nil
            
        case let .changeFavoriteStatus(pokemonId, pokemonName):
            
            return [
                URLQueryItem(name: "pokemonId", value: pokemonId),
                URLQueryItem(name: "pokemonName", value: pokemonName)
            ]
        }
    }
    
    var urlComponents: URLComponents {
        
        switch self {
            
        case .allPokemonModels:
            return self.urlComponents(host: "pokeapi.co", path: "/api/v2/pokemon", queryItems: self.queryItems)
            
        case .pokemon(name: let name):
            return self.urlComponents(host: "pokeapi.co", path: "/api/v2/pokemon/\(name)", queryItems: self.queryItems)
            
        case .changeFavoriteStatus:
            return self.urlComponents(host: "webhook.site", path: "/71e25593-cf64-4201-8a60-962d44a4e71a", queryItems: self.queryItems)
        }
    
    }
    
    private func urlComponents(host: String, path: String, queryItems: [URLQueryItem]? = nil) -> URLComponents {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        urlComponents.queryItems = queryItems

        return urlComponents
    }
}
