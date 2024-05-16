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

                let currentFavoriteStatus = self.interactor.pokemon.isFavorited
                
                /// 1. Update the layout before doing the data work
                let statusToSet = !currentFavoriteStatus
                self.view?.onPokemonDetailViewController(on: self,
                                                         didChangeFavoriteStatusWith: statusToSet)

                /// 2. Invoke interactor to inform that a pokemon did change its favorite status
                try await self.interactor.onPokemonDetailInteractorDidChangeFavoriteStatus(on: self)

                let updatedPokemon = self.interactor.pokemon
                self.pokemon = updatedPokemon
                
                /// 4. Double check if the current pokemon was properly saved with the new status
                if updatedPokemon.isFavorited !=  statusToSet {
                    
                    self.view?.onPokemonDetailViewController(on: self,
                                                             didChangeFavoriteStatusWith: updatedPokemon.isFavorited)
                }
                
            } catch {
                
                print(error.localizedDescription)
                
                /// If an error occurred then we need to set the previous status again
                self.view?.onPokemonDetailViewController(on: self,
                                                         didChangeFavoriteStatusWith: self.interactor.pokemon.isFavorited)
            }
        }
    }
}
