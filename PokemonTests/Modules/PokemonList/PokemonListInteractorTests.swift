//
//  PokemonListInteractorTests.swift
//  PokemonTests
//
//  Created by Miguel Martins on 15/05/2024.
//

import XCTest
@testable import Pokemon

class PokemonListInteractorTests: XCTestCase {
    
    var pokemonListInteractor: PokemonListInteractorType!
    var mockPokemonManager: MockPokemonManager!
    var mockAsyncImageManager: MockAsyncImageManager!
    
    override func setUp()  {
        
        self.mockPokemonManager = MockPokemonManager()
        self.mockPokemonManager.favoritePokemons.insert(1)
        self.mockPokemonManager.favoritePokemons.insert(2)
        self.mockPokemonManager.favoritePokemons.insert(3)
        self.mockAsyncImageManager = MockAsyncImageManager()
        
        self.pokemonListInteractor = PokemonListInteractor(
            pokemonManager: self.mockPokemonManager,
            asyncImageManager: self.mockAsyncImageManager
        )
    }
    
    func testDidFetchFavoriteStatus() {
        
        let presenter = MockPokemonListPresenter(
            interactor: self.pokemonListInteractor,
            router: MockPokemonListRouter(),
            fetchedPokemonViewModels: [],
            refinedPokemonViewModels: [])
        
        var favoriteStatus = self.pokemonListInteractor.onPokemonListInteractor(on: presenter, didfetchFavoriteStatusWith: 1)
        
        XCTAssertTrue(favoriteStatus)
        
        favoriteStatus = self.pokemonListInteractor.onPokemonListInteractor(on: presenter, didfetchFavoriteStatusWith: 4)
        
        XCTAssertFalse(favoriteStatus)
    }
    
    func testDidStoreFavoriteStatus() {
        
        let presenter = MockPokemonListPresenter(
            interactor: self.pokemonListInteractor,
            router: MockPokemonListRouter(),
            fetchedPokemonViewModels: [],
            refinedPokemonViewModels: [])
        
        self.pokemonListInteractor.onPokemonListInteractor(on: presenter, didStoreFavoriteStatusWith: 5, pokemonName: "Charizard")
        
        XCTAssertTrue(self.mockPokemonManager.favoritePokemons.contains(5))
        
        var favoriteStatus = self.pokemonListInteractor.onPokemonListInteractor(on: presenter, didfetchFavoriteStatusWith: 5)
        
        XCTAssertTrue(favoriteStatus)
        
        favoriteStatus = self.pokemonListInteractor.onPokemonListInteractor(on: presenter, didfetchFavoriteStatusWith: 6)
        
        XCTAssertFalse(favoriteStatus)
    }
    
    func testDidSetFavoriteStatus() {
        
        let presenter = MockPokemonListPresenter(
            interactor: self.pokemonListInteractor,
            router: MockPokemonListRouter(),
            fetchedPokemonViewModels: [],
            refinedPokemonViewModels: [])
 
        Task {
            
            do {
                
                var favoriteStatus = try await self.pokemonListInteractor.onPokemonListInteractor(on: presenter, didSetFavoriteStatusWith: 3, pokemonName: "Pikachu")
                
                XCTAssertFalse(favoriteStatus)
                
                favoriteStatus = try await self.pokemonListInteractor.onPokemonListInteractor(on: presenter, didSetFavoriteStatusWith: 3, pokemonName: "Pikachu")
                
                XCTAssertTrue(favoriteStatus)
                
            } catch {
                
                XCTFail("Failed to change favorite status with error \(error)")
            }
        }
    }
    
    /// Missing tests for:
    /// func onPokemonListInteractorFetchInitialPokemons(on pokemonListPresenter: PokemonListPresenterType) async throws -> [Pokemon]
    /// func onPokemonListInteractorfetchNextPokemons(on pokemonListPresenter: PokemonListPresenterType) async throws -> [Pokemon]
    /// func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, didFetchPokemonsWithNamesStartingWith searchText: String) async throws -> [Pokemon]
    
    /// func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, fetchImagesFor imageUrlModels: [PokemonImageUrlModel]) async throws -> [PokemonImageModel]
}
