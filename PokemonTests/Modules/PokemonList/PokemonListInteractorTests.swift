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
    
    func testDidSetFavoriteStatus() {
        
        let presenter = MockPokemonListPresenter(
            interactor: self.pokemonListInteractor,
            router: MockPokemonListRouter(),
            fetchedPokemonViewModels: [],
            refinedPokemonViewModels: [])
 
        Task { @MainActor in
            
            do {
                
                var favoriteStatus = try await self.pokemonListInteractor.onPokemonListInteractor(on: presenter, didSetFavoriteStatusWith: 3, pokemonName: "Pikachu")
                
                XCTAssertFalse(favoriteStatus)
                XCTAssertTrue(self.mockPokemonManager.favoritePokemons.contains(3))
                
                favoriteStatus = self.pokemonListInteractor.onPokemonListInteractor(on: presenter, didfetchFavoriteStatusWith: 3)
                
                XCTAssertTrue(favoriteStatus)
                
                favoriteStatus = try await self.pokemonListInteractor.onPokemonListInteractor(on: presenter, didSetFavoriteStatusWith: 3, pokemonName: "Pikachu")
                
                XCTAssertTrue(favoriteStatus)
                
                favoriteStatus = self.pokemonListInteractor.onPokemonListInteractor(on: presenter, didfetchFavoriteStatusWith: 3)
                
                XCTAssertFalse(favoriteStatus)
                
            } catch {
                
                XCTFail("Failed to change favorite status with error \(error)")
            }
        }
    }
    
    func testFailedDidSetFavoriteStatus() {
        
        let presenter = MockPokemonListPresenter(
            interactor: self.pokemonListInteractor,
            router: MockPokemonListRouter(),
            fetchedPokemonViewModels: [],
            refinedPokemonViewModels: [])
        
        self.mockPokemonManager.shouldThrowError = true
        
        let expectation = XCTestExpectation(description: "Failed to change favorite status")
 
        Task { @MainActor in
            
            do {
                
                let _ = try await self.pokemonListInteractor.onPokemonListInteractor(on: presenter, didSetFavoriteStatusWith: 3, pokemonName: "Pikachu")
                
                XCTFail("Execution should have failed")
                
            } catch {
                
                expectation.fulfill()
            }
        }
    }
    
    func testFetchInitialPokemons() {
        
        let presenter = MockPokemonListPresenter(
            interactor: self.pokemonListInteractor,
            router: MockPokemonListRouter(),
            fetchedPokemonViewModels: [],
            refinedPokemonViewModels: [])
        
        self.mockPokemonManager.allFetchedPokemons.append(contentsOf: [ .mock(), .mock(id: 2, name: "Charmander"), .mock(id: 3, name: "Bulbasaur")])
        
        Task { @MainActor in
            
            do {
                
                let initialPokemons = try await self.pokemonListInteractor.onPokemonListInteractorFetchInitialPokemons(on: presenter)
                
                XCTAssertFalse(initialPokemons.isEmpty)
                XCTAssertEqual(initialPokemons.count, self.mockPokemonManager.allFetchedPokemons.count)
                
            } catch {
                
                XCTFail("Failed to change favorite status with error \(error)")
            }
        }
    }
    
    func testFetchNextPokemons() {
        
        let presenter = MockPokemonListPresenter(
            interactor: self.pokemonListInteractor,
            router: MockPokemonListRouter(),
            fetchedPokemonViewModels: [],
            refinedPokemonViewModels: [])
        
        self.mockPokemonManager.allFetchedPokemons.append(contentsOf: [ .mock(), .mock(id: 2, name: "Charmander"), .mock(id: 3, name: "Bulbasaur")])
        
        Task { @MainActor in
            
            do {
                
                let initialPokemons = try await self.pokemonListInteractor.onPokemonListInteractorFetchInitialPokemons(on: presenter)
                
                XCTAssertFalse(initialPokemons.isEmpty)
                XCTAssertEqual(initialPokemons.count, self.mockPokemonManager.allFetchedPokemons.count)
                
                self.mockPokemonManager.allFetchedPokemons.append(contentsOf: [ .mock(id: 4, name: "Eevee"), .mock(id: 5, name: "Squirtle"), .mock(id: 6, name: "Charizard")])
                
                let nextPokemons = try await self.pokemonListInteractor.onPokemonListInteractorfetchNextPokemons(on: presenter)
                
                XCTAssertFalse(nextPokemons.isEmpty)
                XCTAssertEqual(nextPokemons.count + initialPokemons.count, self.mockPokemonManager.allFetchedPokemons.count)
                
            } catch {
                
                XCTFail("Failed to change favorite status with error \(error)")
            }
        }
    }
    
    func testFetchPokemonsThatStartWithSearchText() {
        
        let presenter = MockPokemonListPresenter(
            interactor: self.pokemonListInteractor,
            router: MockPokemonListRouter(),
            fetchedPokemonViewModels: [],
            refinedPokemonViewModels: [])
        
        self.mockPokemonManager.allFetchedPokemons.append(contentsOf: [ .mock(), .mock(id: 2, name: "Charmander"), .mock(id: 3, name: "Bulbasaur"), .mock(id: 4, name: "Charizard")])
        
        Task { @MainActor in
            
            do {
                
                let refinedPokemons = try await self.pokemonListInteractor.onPokemonListInteractor(on: presenter, didFetchPokemonsWithNamesStartingWith: "Char")
                
                XCTAssertFalse(refinedPokemons.isEmpty)
                XCTAssertEqual(refinedPokemons.count, self.mockPokemonManager.refinedPokemons.count)
                
            } catch {
                
                XCTFail("Failed to change favorite status with error \(error)")
            }
        }
    }
    
    func testFetchImagesForImageUrls() {
        
        let presenter = MockPokemonListPresenter(
            interactor: self.pokemonListInteractor,
            router: MockPokemonListRouter(),
            fetchedPokemonViewModels: [],
            refinedPokemonViewModels: [])
        
        guard let url = URL(string: "https://www.google.com") else { return }
        
        let pokemonImageUrls: [PokemonImageUrlModel] = [PokemonImageUrlModel(row: 1, imageUrl: url), PokemonImageUrlModel(row: 2, imageUrl: url)]
        
        Task { @MainActor in
            
            do {
                
                let pokemonImageUrls = try await self.pokemonListInteractor.onPokemonListInteractor(on: presenter, fetchImagesFor: pokemonImageUrls)
                
                XCTAssertFalse(pokemonImageUrls.isEmpty)
                XCTAssertEqual(2, pokemonImageUrls.count)
                
            } catch {
                
                XCTFail("Failed to change favorite status with error \(error)")
            }
        }
    }
}
