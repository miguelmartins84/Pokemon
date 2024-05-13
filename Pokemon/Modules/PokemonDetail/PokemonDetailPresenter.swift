//
//  PokemonDetailPresenter.swift
//  Pokemon
//
//  Created by Miguel Martins on 10/05/2024.
//

import UIKit

// MARK: - PokemonDetailPresenterType

protocol PokemonDetailPresenterType: AnyObject {
    
    var view: PokemonDetailViewControllerType? { get set }
    var interactor: PokemonDetailInteractorType { get set }
    var router: PokemonDetailRouterType { get set }
    var pokemon: PokemonViewModel? { get set }
    
    func onPokemonDetailPresenter(on pokemonView: PokemonDetailViewControllerType)
    func onPokemonUpdated(on pokemonInteractor: PokemonDetailInteractor, with pokemon: PokemonViewModel)
}

// MARK: - PokemonDetailPresenter

final class PokemonDetailPresenter {
    
    weak var view: PokemonDetailViewControllerType?
    var interactor: PokemonDetailInteractorType
    var router: PokemonDetailRouterType
    
    var pokemon: PokemonViewModel?

    init(
        view: PokemonDetailViewControllerType? = nil,
        interactor: PokemonDetailInteractorType,
        router: PokemonDetailRouterType = PokemonDetailRouter()) {
            
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - PokemonDetailPresenterType implementation

extension PokemonDetailPresenter: PokemonDetailPresenterType {
    
    func onPokemonDetailPresenter(on pokemonView: PokemonDetailViewControllerType) {
        
        self.view = pokemonView
        self.pokemon = self.interactor.pokemon
        self.view?.onPokemonDetailViewControllerStart()
    }
    
    func onPokemonUpdated(on pokemonInteractor: PokemonDetailInteractor, with pokemon: PokemonViewModel) {
        
        
    }
}
