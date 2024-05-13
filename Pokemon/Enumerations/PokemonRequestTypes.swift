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
    
    var url: URL? {
        
        switch self {
            
        case .allPokemonModels:
            
            return self.composeURL(path: "/api/v2/pokemon", queryItems: self.queryItems)
            
        case let .pokemon(name):
            
            return self.composeURL(path: "/api/v2/pokemon/\(name)")
        }
    }
    
    var queryItems: [URLQueryItem]? {
        
        switch self {
            
        case .allPokemonModels:
            
            return [
                URLQueryItem(name: "offset", value: "0"),
                URLQueryItem(name: "limit", value: "100000")
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
