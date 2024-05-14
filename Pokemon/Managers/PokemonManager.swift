//
//  PokemonManager.swift
//  Pokemon
//
//  Created by Miguel Martins on 09/05/2024.
//

import Foundation

// MARK: - PokemonManagerType Definition

protocol PokemonManagerType {
    
    func fetchInitialPokemons() async throws -> [Pokemon]
    func fetchPokemons() async throws -> [Pokemon]
    func fetchPokemons(withNamesStartingWith searchText: String) async throws -> [Pokemon]
    func didChangePokemonFavoriteStatus(with pokemonId: Int, pokemonName: String, isFavorite: Bool) async throws -> Bool
    func didStoreFavoriteStatus(with pokemonId: Int, pokemonName: String, isFavorite: Bool)
}

// MARK: - PokemonManager

class PokemonManager {
    
    // MARK: - Properties
    
    static let shared: PokemonManager = PokemonManager()
    
    private var pokemonService: PokemonServiceType
    private var favoritePokemonsDataManager: FavoritePokemonsDataManagerType
    
    // Stores a dictionary and Set of already fetched pokemons and pages for quicker access
    private var allFetchedPokemonsModelsDictionary: [String: PokemonModel] = [:]
    private var allFetchedPokemonsDictionary: [String: Pokemon] = [:]
    private var currentFetchedPokemonsDictionary: [Int: Pokemon] = [:]
    
    // Stores the ordered pokemon models and all the already fetched pokemons
    private var allPokemonsModels: [PokemonModel] = []
    private var allFetchedPokemons: [Pokemon] = []
    private var allFetchedPages: Set<Int> = []
    private var allOffset = 0
    
    // Stores the refined pokemon models when a user searches (for paging)
    private var refinedPokemonsModels: [PokemonModel] = []
    private var refinedPokemons: [Pokemon] = []
    private var refinedFetchedPages: Set<Int> = []
    private var refinedOffset = 0
    
    private var isInSearchContext: Bool = false

    private let limit = 20
    
//    private lazy var currentPokemonsModels: [PokemonModel] = {
//        
//        self.isInSearchContext ? self.refinedPokemonsModels : self.allPokemonsModels
//    }()
    
//    private lazy var currentPokemons: [Pokemon] = {
//        
//        self.isInSearchContext ? self.refinedPokemons: self.allFetchedPokemons
//    }()
//    
//    private lazy var currentFetchedPages: Set<Int> = {
//        
//        self.isInSearchContext ? self.refinedFetchedPages : self.fetchedPages
//    }()

    init(
        pokemonService: PokemonServiceType = PokemonService(),
        favoritePokemonsDataManager: FavoritePokemonsDataManagerType = FavoritePokemonsDataManager()
    ) {
        
        self.pokemonService = pokemonService
        self.favoritePokemonsDataManager = favoritePokemonsDataManager
    }
}

// MARK: - Private Methods

private extension PokemonManager {
 
    func appendPokemons(with pokemons: [Pokemon]) {
        
//        for pokemon in pokemons {
//            
//            if self.fetchedPokemonsDictionary[pokemon.name] == nil {
//                
//                self.fetchedPokemonsDictionary[pokemon.name] = pokemon
//            }
//        }

        if self.isInSearchContext {
            
            self.refinedPokemons.append(contentsOf: pokemons)
        }
        
//        self.isInSearchContext ?  : self.allFetchedPokemons.append(contentsOf: pokemons)
    }
    
    func clearState(isSearch: Bool) {
        
        if isSearch {
            
            self.isInSearchContext = true
            self.refinedOffset = 0
            self.refinedPokemons = []
            self.refinedFetchedPages = []
            
        } else {
            
            self.isInSearchContext = false
        }
    }
}

// MARK: - PokemonManagerType Implementation

extension PokemonManager: PokemonManagerType {
    
    func fetchInitialPokemons() async throws -> [Pokemon] {
        
        let pokemonModels = try await self.pokemonService.fetchAllPokemonModels()
        self.allPokemonsModels = pokemonModels.sorted(by: { $0.name < $1.name })
        self.allPokemonsModels.forEach { pokemonModel in
            
            self.allFetchedPokemonsModelsDictionary[pokemonModel.name] = pokemonModel
        }
        
        let initialPokemonModels = Array(self.allPokemonsModels[0 ..< self.limit])
                
        try await self.loadPokemons(from: initialPokemonModels)
        
        let sortedPokemons = self.getSortedPokemonsFromCurrentlyFetched()
        
        self.allFetchedPokemons = sortedPokemons
        self.allFetchedPages.insert(1)
        self.allOffset += sortedPokemons.count

        return self.allFetchedPokemons
    }
    
    private func getSortedPokemonsFromCurrentlyFetched() -> [Pokemon] {
        
        var currentFetchedPokemons: [Pokemon] = []
        
        let keys = self.currentFetchedPokemonsDictionary.keys.sorted()
        
        for key in keys {
            
            if let pokemon = self.currentFetchedPokemonsDictionary[key] {
                
                currentFetchedPokemons.append(pokemon)
            }
        }
        
        return currentFetchedPokemons
    }

    private func loadPokemons(from pokemonModels: [PokemonModel]) async throws {
        
        self.currentFetchedPokemonsDictionary = [:]
        
        return try await withThrowingTaskGroup(of: Pokemon.self) { group in
            
            for pokemonModel in pokemonModels {
                
                group.addTask {
                    
                    let pokemonName = pokemonModel.name
                    
                    let pokemon = try await self.pokemonService.fetchPokemon(for: pokemonName)
                    return pokemon
                }
            }
            
            for try await fetchedPokemon in group {

                self.currentFetchedPokemonsDictionary[fetchedPokemon.id] = fetchedPokemon
            }
        }
    }
    
//    func fetchAllPokemonModels() async throws {
//        
//        let pokemonsModels = try await self.pokemonService.fetchAllPokemonModels()
//        self.allPokemonsModels = pokemonsModels.sorted(by: { $0.name < $1.name })
//        self.allPokemonsModels.forEach { pokemonModel in
//            
//            self.fetchedPokemonsModelsDictionary[pokemonModel.name] = pokemonModel
//        }
//    }
    
    func fetchPokemons() async throws -> [Pokemon] {
        
        let currentPokemonsModels = self.isInSearchContext ? self.refinedPokemonsModels : self.allPokemonsModels
        let currentFetchedPages = self.isInSearchContext ? self.refinedFetchedPages : self.allFetchedPages
        let currentPokemons = self.isInSearchContext ? self.refinedPokemons : self.allFetchedPokemons
        let offset = self.isInSearchContext ? self.refinedOffset : self.allOffset
        
        let numberOfPages = currentPokemonsModels.count / limit
        
        let currentPage = offset == 0 ? 1 : (offset / limit) + 1
        
        if currentFetchedPages.contains(currentPage) == false {
            
            let lastIndexToFetch = limit * currentPage
            
            if offset <= lastIndexToFetch, currentPage <= numberOfPages {
                
                let pokemonModels = Array(currentPokemonsModels[offset ..< lastIndexToFetch])
                try await self.loadPokemons(from: pokemonModels)
                
                let fetchedPokemons = self.getSortedPokemonsFromCurrentlyFetched()
                  
                if self.isInSearchContext {

                    self.refinedFetchedPages.insert(currentPage)
                    self.refinedOffset += fetchedPokemons.count
                    self.refinedPokemons.append(contentsOf: fetchedPokemons)

                } else {
                    
                    self.allFetchedPages.insert(currentPage)
                    self.allOffset += fetchedPokemons.count
                    self.allFetchedPokemons.append(contentsOf: fetchedPokemons)
                }
                
                print("Fetched page: \(currentPage) with offset: \(offset) to \(lastIndexToFetch) with maximum: \(currentPokemonsModels.count) current pokemons: \(currentPokemons.count)")
                
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
            
            for pokemonModel in filteredPokemonsModels {
                
                if let fetchedPokemon = self.allFetchedPokemonsDictionary[pokemonModel.name] {
                    
                    alreadyFetchedPokemons.append(fetchedPokemon)
                    
                } else {
                    
                    pokemonModelsToFetch.append(pokemonModel)
                }
            }
            
            var refinedPokemons: [Pokemon] = alreadyFetchedPokemons
            
            if pokemonModelsToFetch.isEmpty == false {
                
                let fetchedPokemons = try await self.pokemonService.fetchPokemons(from: pokemonModelsToFetch)
                refinedPokemons.append(contentsOf: fetchedPokemons)
            }
            
            self.refinedPokemons = refinedPokemons.sorted(by: { $0.name < $1.name})
            self.refinedPokemons.forEach( { self.allFetchedPokemonsDictionary[$0.name] = $0 } )
            self.refinedFetchedPages.insert(1)

            return refinedPokemons
            
        } else {
            
            self.clearState(isSearch: false)
            return self.allFetchedPokemons
        }
    }
    
    func didStoreFavoriteStatus(with pokemonId: Int, pokemonName: String, isFavorite: Bool) {
        
        let favoritePokemon = FavoritePokemonDataModel()
        favoritePokemon.id = pokemonId
        favoritePokemon.name = pokemonName
        
        if isFavorite == true {
            
            self.favoritePokemonsDataManager.addToFavorites(favoritePokemonDataModel: favoritePokemon)
            
        } else {
            
            self.favoritePokemonsDataManager.removeFromFavorites(favoritePokemonDataModel: favoritePokemon)
        }
    }
    
    func didChangePokemonFavoriteStatus(with pokemonId: Int, pokemonName: String, isFavorite: Bool) async throws -> Bool {
        
        if isFavorite == true {
            
            let favoriteStatus = try await self.pokemonService.addPokemonToFavorites(with: pokemonId, pokemonName: pokemonName)

            
            return favoriteStatus
        } else {
            
            let favoriteStatus = try await self.pokemonService.removePokemonFromFavorites(with: pokemonId, pokemonName: pokemonName)
            
            return favoriteStatus
        }
    }
}
