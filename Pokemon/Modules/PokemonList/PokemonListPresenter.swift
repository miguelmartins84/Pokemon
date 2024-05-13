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
    func onPokemonListPresenter(on pokemonListView: PokemonListViewController, userSearchedForText searchText: String)
    func fetchNextPokemons(on pokemonListView: PokemonListViewControllerType)
    
}

// MARK: - PokemonListPresenter

final class PokemonListPresenter {
    
    weak var view: PokemonListViewControllerType?
    var interactor: PokemonListInteractorType
    var router: PokemonListRouterType
    
    var pokemons: [Pokemon] = []
    let page: Int = 1
    
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
                
                try await self.interactor.fetchAllPokemonsModels()                
                    
                let pokemons = try await self.interactor.fetchNextPokemons()
                self.pokemons.append(contentsOf: pokemons)
                self.view?.onFetchPokemons(on: self, with: pokemons)

            } catch {
                
                print("Error: \(error)")
            }
        }
    }
    
    func fetchNextPokemons(on pokemonListView: PokemonListViewControllerType) {
        
        Task { @MainActor in
            
            do {
                    
                let pokemons = try await self.interactor.fetchNextPokemons()
                self.pokemons.append(contentsOf: pokemons)
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
    
    func onPokemonListPresenter(on pokemonListView: PokemonListViewController, userSearchedForText searchText: String) {

        Task { @MainActor in
            
            do {
                
                let pokemons = try await self.interactor.fetchPokemons(withNamesStartingWith: searchText)
                self.pokemons = pokemons
                self.view?.onFetchPokemons(on: self, with: pokemons)
                
            } catch {
                
                print("Error: \(error)")
            }
        }
    }
}
