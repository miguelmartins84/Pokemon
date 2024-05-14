//
//  PokemonManagerTests.swift
//  PokemonTests
//
//  Created by Miguel Martins on 14/05/2024.
//

import XCTest
@testable import Pokemon

final class PokemonManagerTests: XCTestCase {
    
    private var pokemonManager: PokemonManagerType!
    private var mockPokemonService: PokemonServiceType!
    private var mockFavoritePokemonsDataManager: FavoritePokemonsDataManagerType!

    override func tearDown() {
        
        self.pokemonManager = nil
        self.mockPokemonService = nil
        self.mockFavoritePokemonsDataManager = nil
    }

    func testFetchInitialPokemons() async {
        
        do {
            
            let pokemon = Pokemon(id: 2, name: "Pikachu", height: 50, weight: 100, types: [.init(type: .init(name: "Pikachu", url: "Pikachu"))], sprites: .init(otherSprites: .init(officialArtwork: nil)), stats: [], order: 1)
            let pokemon2 = Pokemon(id: 1, name: "Bulbasaur", height: 50, weight: 100, types: [.init(type: .init(name: "Bulbasaur", url: "Bulbasaur"))], sprites: .init(otherSprites: .init(officialArtwork: nil)), stats: [], order: 2)
            let pokemon3 = Pokemon(id: 3, name: "Squirtle", height: 50, weight: 100, types: [.init(type: .init(name: "Squirtle", url: "Squirtle"))], sprites: .init(otherSprites: .init(officialArtwork: nil)), stats: [], order: 3)
            let favoritePokemonDataModel = MockFavoritePokemonDataModel(pokemonId: 1, pokemonName: "Bulbasaur")
            
            let pokemonModel = PokemonModel(name: "Pikachu", url: "Pikachu")
            let pokemon2Model = PokemonModel(name: "Bulbasaur", url: "Bulbasaur")
            let pokemon3Model = PokemonModel(name: "Squirtle", url: "Squirtle")
            
            let pokemonService = MockPokemonService(pokemonModels: [pokemonModel, pokemon2Model, pokemon3Model], 
                                                    pokemons: [pokemon, pokemon2, pokemon3],
                                                    favoritePokemons: [favoritePokemonDataModel])

            let favoritePokemonsDataManager = MockFavoritePokemonsDataManager(favoritePokemons: [favoritePokemonDataModel])
            self.mockPokemonService = pokemonService
            self.mockFavoritePokemonsDataManager = favoritePokemonsDataManager
            
            self.pokemonManager = PokemonManager(pokemonService: pokemonService,
                                                 favoritePokemonsDataManager: favoritePokemonsDataManager)
            
            let pokemons = try await self.pokemonManager.fetchInitialPokemons()
            
            XCTAssertEqual(3, pokemons.count)
            
            /// Validate that the pokemons array is sorted by id
            XCTAssertEqual(pokemons.first?.name, "Bulbasaur")
            XCTAssertEqual(pokemons[1].name, "Pikachu")
            XCTAssertEqual(pokemons.last?.name, "Squirtle")
            XCTAssertTrue(self.pokemonManager.favoritePokemons.contains(1))
            
        } catch {
            
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDidChangePokemonFavoriteStatusToTrue() async {
        
        do {
            let favoritePokemonDataModel = MockFavoritePokemonDataModel(pokemonId: 1, pokemonName: "Pikachu")
            
            let pokemonService = MockPokemonService(pokemonModels: [], pokemons: [], favoritePokemons: [favoritePokemonDataModel])
            let favoritePokemonsDataManager = MockFavoritePokemonsDataManager()
            self.mockPokemonService = pokemonService
            self.mockFavoritePokemonsDataManager = favoritePokemonsDataManager
            
            self.pokemonManager = PokemonManager(pokemonService: pokemonService,
                                                 favoritePokemonsDataManager: favoritePokemonsDataManager)
            
            let favoriteStatus = try await self.pokemonManager.didChangePokemonFavoriteStatus(with: 1, pokemonName: "Pikachu", isFavorite: true)
            
            XCTAssertTrue(favoriteStatus)
            
        } catch {
            
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDidChangePokemonFavoriteStatusToFalse() async {
        
        do {
            
            let pokemon = Pokemon(id: 1, name: "Pikachu", height: 50, weight: 100, types: [.init(type: .init(name: "pikachu", url: "pikachu"))], sprites: .init(otherSprites: .init(officialArtwork: nil)), stats: [], order: 1)
            let favoritePokemonDataModel = MockFavoritePokemonDataModel(pokemonId: 1, pokemonName: "Pikachu")
            
            let pokemonService = MockPokemonService(pokemonModels: [], pokemons: [pokemon], favoritePokemons: [favoritePokemonDataModel])
            let favoritePokemonsDataManager = MockFavoritePokemonsDataManager()
            self.mockPokemonService = pokemonService
            self.mockFavoritePokemonsDataManager = favoritePokemonsDataManager
            
            self.pokemonManager = PokemonManager(pokemonService: pokemonService,
                                                 favoritePokemonsDataManager: favoritePokemonsDataManager)
            
            let favoriteStatus = try await self.pokemonManager.didChangePokemonFavoriteStatus(with: 1, pokemonName: "Pikachu", isFavorite: false)
            
            XCTAssertFalse(favoriteStatus)
            
        } catch {
            
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFetchFavoriteStatus() {
        
        let pokemon = Pokemon(id: 2, name: "Pikachu", height: 50, weight: 100, types: [.init(type: .init(name: "Pikachu", url: "Pikachu"))], sprites: .init(otherSprites: .init(officialArtwork: nil)), stats: [], order: 1)
        let pokemon2 = Pokemon(id: 1, name: "Bulbasaur", height: 50, weight: 100, types: [.init(type: .init(name: "Bulbasaur", url: "Bulbasaur"))], sprites: .init(otherSprites: .init(officialArtwork: nil)), stats: [], order: 2)
        let pokemon3 = Pokemon(id: 3, name: "Squirtle", height: 50, weight: 100, types: [.init(type: .init(name: "Squirtle", url: "Squirtle"))], sprites: .init(otherSprites: .init(officialArtwork: nil)), stats: [], order: 3)
        let favoritePokemonDataModel = MockFavoritePokemonDataModel(pokemonId: 1, pokemonName: "Bulbasaur")
        
        let pokemonModel = PokemonModel(name: "Pikachu", url: "Pikachu")
        let pokemon2Model = PokemonModel(name: "Bulbasaur", url: "Bulbasaur")
        let pokemon3Model = PokemonModel(name: "Squirtle", url: "Squirtle")
        
        let pokemonService = MockPokemonService(pokemonModels: [pokemonModel, pokemon2Model, pokemon3Model],
                                                pokemons: [pokemon, pokemon2, pokemon3],
                                                favoritePokemons: [favoritePokemonDataModel])

        let favoritePokemonsDataManager = MockFavoritePokemonsDataManager(favoritePokemons: [favoritePokemonDataModel])
        self.mockPokemonService = pokemonService
        self.mockFavoritePokemonsDataManager = favoritePokemonsDataManager
        
        self.pokemonManager = PokemonManager(pokemonService: pokemonService,
                                             favoritePokemonsDataManager: favoritePokemonsDataManager)
        
        let favoriteStatus = self.pokemonManager.fetchFavoriteStatus(for: 1)
        XCTAssertTrue(favoriteStatus)
        
        let missingFavoriteStatus = self.pokemonManager.fetchFavoriteStatus(for: 2)
        XCTAssertFalse(missingFavoriteStatus)

    }
    
    func testStoreFavoriteStatus() {
        
        let pokemon = Pokemon(id: 2, name: "Pikachu", height: 50, weight: 100, types: [.init(type: .init(name: "Pikachu", url: "Pikachu"))], sprites: .init(otherSprites: .init(officialArtwork: nil)), stats: [], order: 1)
        let pokemon2 = Pokemon(id: 1, name: "Bulbasaur", height: 50, weight: 100, types: [.init(type: .init(name: "Bulbasaur", url: "Bulbasaur"))], sprites: .init(otherSprites: .init(officialArtwork: nil)), stats: [], order: 2)
        let pokemon3 = Pokemon(id: 3, name: "Squirtle", height: 50, weight: 100, types: [.init(type: .init(name: "Squirtle", url: "Squirtle"))], sprites: .init(otherSprites: .init(officialArtwork: nil)), stats: [], order: 3)
        let favoritePokemonDataModel = MockFavoritePokemonDataModel(pokemonId: 1, pokemonName: "Bulbasaur")
        
        let pokemonModel = PokemonModel(name: "Pikachu", url: "Pikachu")
        let pokemon2Model = PokemonModel(name: "Bulbasaur", url: "Bulbasaur")
        let pokemon3Model = PokemonModel(name: "Squirtle", url: "Squirtle")
        
        let pokemonService = MockPokemonService(pokemonModels: [pokemonModel, pokemon2Model, pokemon3Model],
                                                pokemons: [pokemon, pokemon2, pokemon3],
                                                favoritePokemons: [favoritePokemonDataModel])

        let favoritePokemonsDataManager = MockFavoritePokemonsDataManager(favoritePokemons: [favoritePokemonDataModel])
        self.mockPokemonService = pokemonService
        self.mockFavoritePokemonsDataManager = favoritePokemonsDataManager
        
        self.pokemonManager = PokemonManager(pokemonService: pokemonService,
                                             favoritePokemonsDataManager: favoritePokemonsDataManager)
        
        self.pokemonManager.didStoreFavoriteStatus(with: 4, pokemonName: "Charmander", isFavorite: true)
        
        XCTAssertEqual(2, favoritePokemonsDataManager.favoritePokemons.count)
        
        self.pokemonManager.didStoreFavoriteStatus(with: 4, pokemonName: "Charmander", isFavorite: false)
        
        XCTAssertEqual(1, favoritePokemonsDataManager.favoritePokemons.count)
        
    }
    
    /// Missing tests for:
    ///    func fetchPokemons() async throws -> [Pokemon]
    ///    func fetchPokemons(withNamesStartingWith searchText: String) async throws -> [Pokemon]
    
//    func testNextPokemons() async {
//
//        do {
//
//            let pokemon = Pokemon(id: 2, name: "Pikachu", height: 50, weight: 100, types: [.init(type: .init(name: "Pikachu", url: "Pikachu"))], sprites: .init(otherSprites: .init(officialArtwork: nil)), stats: [], order: 1)
//            let pokemon2 = Pokemon(id: 1, name: "Bulbasaur", height: 50, weight: 100, types: [.init(type: .init(name: "Bulbasaur", url: "Bulbasaur"))], sprites: .init(otherSprites: .init(officialArtwork: nil)), stats: [], order: 2)
//            let pokemon3 = Pokemon(id: 3, name: "Squirtle", height: 50, weight: 100, types: [.init(type: .init(name: "Squirtle", url: "Squirtle"))], sprites: .init(otherSprites: .init(officialArtwork: nil)), stats: [], order: 3)
//            let pokemon4 = Pokemon(id: 4, name: "Eeevee", height: 50, weight: 100, types: [.init(type: .init(name: "Eeevee", url: "Eeevee"))], sprites: .init(otherSprites: .init(officialArtwork: nil)), stats: [], order: 3)
//            let pokemon5 = Pokemon(id: 4, name: "Charmander", height: 50, weight: 100, types: [.init(type: .init(name: "Charmander", url: "Charmander"))], sprites: .init(otherSprites: .init(officialArtwork: nil)), stats: [], order: 3)
//            let favoritePokemonDataModel = MockFavoritePokemonDataModel(pokemonId: 1, pokemonName: "Pikachu")
//
//            let pokemonModel = PokemonModel(name: "Pikachu", url: "Pikachu")
//            let pokemon2Model = PokemonModel(name: "Bulbasaur", url: "Bulbasaur")
//            let pokemon3Model = PokemonModel(name: "Squirtle", url: "Squirtle")
//            let pokemon4Model = PokemonModel(name: "Eevee", url: "Eeevee")
//            let pokemon5Model = PokemonModel(name: "Charmander", url: "Charmander")
//
//
//            let pokemonService = MockPokemonService(pokemonModels: [pokemonModel, pokemon2Model, pokemon3Model],
//                                                    pokemons: [pokemon, pokemon2, pokemon3],
//                                                    favoritePokemons: [favoritePokemonDataModel])
//
//
//            let favoritePokemonsDataManager = MockFavoritePokemonsDataManager()
//            self.mockPokemonService = pokemonService
//            self.mockFavoritePokemonsDataManager = favoritePokemonsDataManager
//
//            self.pokemonManager = PokemonManager(pokemonService: pokemonService,
//                                                 favoritePokemonsDataManager: favoritePokemonsDataManager)
//
//            let _ = try await self.pokemonManager.fetchInitialPokemons()
//
//            pokemonService.appendPokemonModels(with: [pokemon4Model, pokemon5Model])
//            pokemonService.appendPokemons(with: [pokemon4, pokemon5])
//
//            let pokemons = try await self.pokemonManager.fetchPokemons()
//
//            XCTAssertEqual(5, pokemons.count)
//
//            /// Validate that the pokemons array is sorted by id
//            XCTAssertEqual(pokemons.first?.name, "Bulbasaur")
//            XCTAssertEqual(pokemons[1].name, "Pikachu")
//            XCTAssertEqual(pokemons.last?.name, "Squirtle")
//
//        } catch {
//
//            XCTFail(error.localizedDescription)
//        }
//    }
}
