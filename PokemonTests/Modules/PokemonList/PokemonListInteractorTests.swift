//
//  PokemonListInteractorTests.swift
//  PokemonTests
//
//  Created by Miguel Martins on 15/05/2024.
//

import XCTest
@testable import Pokemon

class PokemonListInteractorTests: XCTestCase {
    
    override func setUp()  {
        
//        let pokemonListInteractor = PokemonListInteractor(
//            pokemonManager: MockPokemonManager(),
//            asyncImageManager MockAsyncImageManager():
//        )
    }
    
    /// Missing tests for:
    /// func onPokemonListInteractorFetchInitialPokemons(on pokemonListPresenter: PokemonListPresenterType) async throws -> [Pokemon]
    /// func onPokemonListInteractorfetchNextPokemons(on pokemonListPresenter: PokemonListPresenterType) async throws -> [Pokemon]
    /// func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, didFetchPokemonsWithNamesStartingWith searchText: String) async throws -> [Pokemon]
    /// func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, didfetchFavoriteStatusWith pokemonId: Int) -> Bool
    /// func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, didSetFavoriteStatusWith pokemonId: Int, pokemonName: String) async throws -> Bool
    /// func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, didStoreFavoriteStatusWith pokemonId: Int, pokemonName: String)
    /// func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, fetchImagesFor imageUrlModels: [PokemonImageUrlModel]) async throws -> [PokemonImageModel]
}
