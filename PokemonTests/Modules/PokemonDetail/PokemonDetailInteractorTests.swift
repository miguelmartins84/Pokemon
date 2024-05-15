//
//  PokemonDetailInteractorTests.swift
//  PokemonTests
//
//  Created by Miguel Martins on 15/05/2024.
//

import Foundation
import XCTest
@testable import Pokemon

class PokemonDetailInteractorTests: XCTestCase {
    
    var pokemonDetailInteractor: PokemonDetailInteractorType!
    var mockPokemonManager: MockPokemonManager!
    
    override func setUp()  {
        
        self.mockPokemonManager = MockPokemonManager()
        self.mockPokemonManager.favoritePokemons.insert(1)
        self.mockPokemonManager.favoritePokemons.insert(2)
        self.mockPokemonManager.favoritePokemons.insert(3)
        self.pokemonDetailInteractor = PokemonDetailInteractor(pokemon: PokemonViewModel.mock(id: 4, name: "Charizard"),
                                                               pokemonManager: self.mockPokemonManager)
    }
    
    func testDidStoreFavoriteStatus() {
        
        let pokemonDetailPresenter: PokemonDetailPresenterType = MockPokemonDetailPresenter(
            view: nil,
            interactor: self.pokemonDetailInteractor,
            router: MockPokemonDetailRouter()
        )
        
        self.pokemonDetailInteractor.onPokemonDetailInteractorDidStoreFavoriteStatus(on: pokemonDetailPresenter)
        
        XCTAssertTrue(self.mockPokemonManager.fetchFavoriteStatus(for: 4))
    }
    
    func testDidChangeFavoriteStatus() {
        
        let pokemonDetailPresenter: PokemonDetailPresenterType = MockPokemonDetailPresenter(
            view: nil,
            interactor: self.pokemonDetailInteractor,
            router: MockPokemonDetailRouter()
        )
        
        Task {
            
            do {
                
                try await self.pokemonDetailInteractor.onPokemonDetailInteractorDidChangeFavoriteStatus(on: pokemonDetailPresenter)
                
                XCTAssertTrue(self.pokemonDetailInteractor.pokemon.isFavorited)
                
                try await self.pokemonDetailInteractor.onPokemonDetailInteractorDidChangeFavoriteStatus(on: pokemonDetailPresenter)
                
                XCTAssertFalse(self.pokemonDetailInteractor.pokemon.isFavorited)
                
            } catch {
                
                XCTFail("Failed to change favorite status with error \(error)")
            }
        }
    }
    
    func testFailedToChangeFavoriteStatus() {
        
        let pokemonDetailPresenter: PokemonDetailPresenterType = MockPokemonDetailPresenter(
            view: nil,
            interactor: self.pokemonDetailInteractor,
            router: MockPokemonDetailRouter()
        )
        
        self.mockPokemonManager.shouldThrowError = true
        
        let expectation = XCTestExpectation(description: "Failed to change favorite status")
        
        Task {
            
            do {
                
                try await self.pokemonDetailInteractor.onPokemonDetailInteractorDidChangeFavoriteStatus(on: pokemonDetailPresenter)
                
                XCTFail("Execution should have failed")
                
            } catch {
                
                expectation.fulfill()
            }
        }
    }
}
