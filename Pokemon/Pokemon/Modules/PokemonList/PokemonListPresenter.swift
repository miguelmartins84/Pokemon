//
//  PokemonListPresenter.swift
//  Marvel
//
//  Created by Miguel Martins on 04/05/2024.
//

import UIKit

// MARK: - PokemonListPresenterType

protocol PokemonListPresenterType: AnyObject {
    
    var view: PokemonListViewControllerType? { get set }
    var interactor: PokemonListInteractorType { get set }
    var router: PokemonListRouterType { get set }
    
    var pokemons: [Pokemon] { get }
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType)
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, pokemonCellTappedWith pokemonViewModel: PokemonViewModel)
}

// MARK: - PokemonListPresenter

final class PokemonListPresenter {
    
    weak var view: PokemonListViewControllerType?
    var interactor: PokemonListInteractorType
    var router: PokemonListRouterType
    
    var pokemons: [Pokemon] = []
    
    init(
        view: PokemonListViewControllerType? = nil,
        interactor: PokemonListInteractorType = PokemonListInteractor(),
        router: PokemonListRouterType = PokemonListRouter()
    ) {

        self.interactor = interactor
        self.router = router
    }
}

// MARK: - PokemonListPresenterType implementation

extension PokemonListPresenter: PokemonListPresenterType {
    
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType) {
        
        self.view = pokemonListView
        
        Task { @MainActor in
            
            do {
                    
                let pokemons = try await self.interactor.fetchPokemons()
                self.pokemons = pokemons
                self.view?.onFetchPokemons(on: self, with: pokemons)

            } catch {
                
                print("Error: \(error)")
            }
        }
    }

    func onPokemonListPresenter(on pokemonListView: any PokemonListViewControllerType, pokemonCellTappedWith pokemonViewModel: PokemonViewModel) {
        
        print("Navigate to cell at \(pokemonViewModel.name)")
        self.router.showPokemonDetail(with: pokemonViewModel)
    }
}
