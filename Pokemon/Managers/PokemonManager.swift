//
//  PokemonManager.swift
//  Pokemon
//
//  Created by Miguel Martins on 09/05/2024.
//

import Foundation

// MARK: - PokemonManagerType Definition

protocol PokemonManagerType {
    
    func fetchAllPokemonsModels() async throws
    func fetchNextPokemons() async throws -> [Pokemon]
    func fetchPokemons(withNamesStartingWith searchText: String) async throws -> [Pokemon]
}

// MARK: - PokemonManager

class PokemonManager {
    
    static let shared: PokemonManager = PokemonManager(pokemonService: PokemonService())
    
    private var allPokemonsModels: [PokemonModel] = []
    private var refinedPokemonsModels: [PokemonModel] = []
    private var fetchedPokemons: [Pokemon] = []
    private var refinedPokemons: [Pokemon] = []
    private var fetchedPokemonsDictionary: [String: Pokemon] = [:]
    
    private var pokemonService: PokemonServiceType
    
    private var offset = 0
    private let limit = 20
    
    private var fetchedPages: Set<Int> = []
    private var lastFetchedPage = 0
    
    private var isInSearchContext: Bool = false
    
    private lazy var currentPokemonsModels: [PokemonModel] = {
        
        self.isInSearchContext ? self.refinedPokemonsModels : self.allPokemonsModels
    }()
    
    private lazy var currentPokemons: [Pokemon] = {
        
        self.isInSearchContext ? self.refinedPokemons: self.fetchedPokemons
    }()

    init(pokemonService: PokemonServiceType) {
        
        self.pokemonService = pokemonService
    }
}

// MARK: - Private Methods

private extension PokemonManager {
 
    func appendPokemons(with pokemons: [Pokemon]) {
        
        self.isInSearchContext ? self.refinedPokemons.append(contentsOf: pokemons) : self.fetchedPokemons.append(contentsOf: pokemons)
    }
    
    func clearState(isSearch: Bool = false) {
                
        self.isInSearchContext = isSearch
        self.lastFetchedPage = 0
        self.offset = 0
        self.fetchedPages.removeAll()
    }
}

// MARK: - PokemonManagerType Implementation

extension PokemonManager: PokemonManagerType {
    
    func fetchAllPokemonsModels() async throws {
        
        let pokemonsModels = try await self.pokemonService.fetchAllPokemonModels()
        self.allPokemonsModels = pokemonsModels
    }
    
    func fetchNextPokemons() async throws -> [Pokemon] {
        
        let numberOfPages = self.currentPokemonsModels.count / self.limit
        
        let page = self.lastFetchedPage + 1
        
        if fetchedPages.contains(page) == false {
            
            let lastIndexToFetch = self.limit * page
            
            if self.offset <= lastIndexToFetch, page <= numberOfPages {
                
                let pokemonsModels = Array(self.currentPokemonsModels[self.offset ..< lastIndexToFetch])
                let fetchedPokemons = try await self.pokemonService.fetchPokemons(from: pokemonsModels)
                
                self.appendPokemons(with: fetchedPokemons)
                fetchedPokemons.forEach( { self.fetchedPokemonsDictionary[$0.name] = $0 } )
                
                print("Fetched page: \(page) with offset: \(self.offset) to \(lastIndexToFetch) with maximum: \(self.currentPokemonsModels.count) current pokemons: \(self.currentPokemons.count)")
                self.offset += fetchedPokemons.count
                self.lastFetchedPage = page
                self.fetchedPages.insert(page)
                
                return fetchedPokemons
            }
        }

        return []
    }
    
    func fetchPokemons(withNamesStartingWith searchText: String) async throws -> [Pokemon] {
        
        if searchText.isEmpty == false {
            
            self.clearState(isSearch: true)
            
            let filteredPokemonsModels = self.allPokemonsModels.filter( { $0.name.hasPrefix(searchText.lowercased())})
            print(filteredPokemonsModels.map { $0.name })
            
            self.refinedPokemonsModels = filteredPokemonsModels
            
            var alreadyFetchedPokemons: [Pokemon] = []
            var pokemonModelsToFetch: [PokemonModel] = []
            
            for pokemon in filteredPokemonsModels {
                
                if let pokemon = self.fetchedPokemonsDictionary[pokemon.name] {
                    
                    alreadyFetchedPokemons.append(pokemon)
                    
                } else {
                    
                    pokemonModelsToFetch.append(pokemon)
                }
            }
            
            var refinedPokemons = try await self.pokemonService.fetchPokemons(from: pokemonModelsToFetch)
            refinedPokemons.append(contentsOf: alreadyFetchedPokemons)
            
            self.refinedPokemons = refinedPokemons
            
            refinedPokemons.forEach( { self.fetchedPokemonsDictionary[$0.name] = $0 } )

            return refinedPokemons
            
        } else {
            
            self.clearState()
            return self.fetchedPokemons
        }
    }
}
