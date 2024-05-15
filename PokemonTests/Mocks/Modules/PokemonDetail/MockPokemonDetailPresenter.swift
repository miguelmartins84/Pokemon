//
//  MockPokemonDetailPresenter.swift
//  PokemonTests
//
//  Created by Miguel Martins on 15/05/2024.
//

import Foundation
@testable import Pokemon

class MockPokemonDetailPresenter: PokemonDetailPresenterType {
    
    var view: PokemonDetailViewControllerType?
    
    var interactor: PokemonDetailInteractorType
    
    var router: PokemonDetailRouterType
    
    var pokemon: PokemonViewModel?
    
    init(view: PokemonDetailViewControllerType? = nil, 
         interactor: PokemonDetailInteractorType,
         router: PokemonDetailRouterType,
         pokemon: PokemonViewModel? = nil) {

        self.view = view
        self.interactor = interactor
        self.router = router
        self.pokemon = pokemon
    }
    
    func onPokemonDetailPresenter(on pokemonDetailView: PokemonDetailViewControllerType) {
        
    }
    
    func onPokemonDetailPresenterDidChangeFavoriteStatus(on pokemonDetailView: PokemonDetailViewControllerType) {
        
    }
}
