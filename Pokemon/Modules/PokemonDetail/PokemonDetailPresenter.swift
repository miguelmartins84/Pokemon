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
        
    func onPokemonDetailPresenter(on pokemonDetailView: PokemonDetailViewControllerType)
    func onPokemonDetailPresenterDidChangeFavoriteStatus(on pokemonDetailView: PokemonDetailViewControllerType)
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
 
    func onPokemonDetailPresenter(on pokemonDetailView: PokemonDetailViewControllerType) {
        
        self.view = pokemonDetailView
        self.pokemon = self.interactor.pokemon
        self.view?.onPokemonDetailViewController(on: self)
    }
    
    func onPokemonDetailPresenterDidChangeFavoriteStatus(on pokemonDetailView: PokemonDetailViewControllerType) {
        
        Task { @MainActor in
            
            do {
            
                try await self.interactor.onPokemonDetailInteractorDidChangeFavoriteStatus(on: self)
                
                self.interactor.onPokemonDetailInteractorDidStoreFavoriteStatus(on: self)

                let pokemon = self.interactor.pokemon
                self.pokemon = pokemon
                self.view?.onPokemonDetailViewController(on: self,
                                                         didChangeFavoriteStatusWith: pokemon.isFavorited)
                
            } catch {
                
                print(error.localizedDescription)
            }
        }
    }
}
