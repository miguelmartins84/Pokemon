//
//  MockPokemonListPresenter.swift
//  PokemonTests
//
//  Created by Miguel Martins on 15/05/2024.
//

import Foundation
@testable import Pokemon

class MockPokemonListPresenter: PokemonListPresenterType {
    
    var view: PokemonListViewControllerType?
    
    var interactor: PokemonListInteractorType
    
    var router: PokemonListRouterType
    
    var fetchedPokemonViewModels: [PokemonViewModel]
    
    var refinedPokemonViewModels: [PokemonViewModel]
    
    init(view: PokemonListViewControllerType? = nil, 
         interactor: PokemonListInteractorType,
         router: PokemonListRouterType,
         fetchedPokemonViewModels: [PokemonViewModel],
         refinedPokemonViewModels: [PokemonViewModel]) {

        self.view = view
        self.interactor = interactor
        self.router = router
        self.fetchedPokemonViewModels = fetchedPokemonViewModels
        self.refinedPokemonViewModels = refinedPokemonViewModels
    }
    
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType) {
        
    }
    
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, pokemonCellTappedWith pokemonViewModel: PokemonViewModel) {
        
    }
    
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, userSearchedForText searchText: String) {
        
    }
    
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, userTappedFavoriteButtonWith: PokemonViewModel) {
        
    }
    
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, fetchPokemonViewModelFor row: Int) -> PokemonViewModel? {
        
        return nil
    }
    
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, fetchImagesfor rows: [Int], isInitialFetch: Bool) async {
        
    }
    
    func onPokemonListPresenterFetchNextPokemons(on pokemonListView: PokemonListViewControllerType) {
        
    }
    
    func onPokemonListPresenterFetchNumberOfPokemons(on pokemonListView: PokemonListViewControllerType) -> Int {
        
        return 0
    }
    
    func onPokemonListInteractor(on pokemoListInteractor: PokemonListInteractorType, didChangeFavoriteStatusOf pokemonId: Int) {
        
    }
}
