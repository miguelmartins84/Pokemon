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
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, userSearchedForText searchText: String)
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, userTappedFavoriteButtonWith: PokemonViewModel)
    func fetchNextPokemonsOnPokemonListPresenter(on pokemonListView: PokemonListViewControllerType)
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
                
                let pokemons = try await self.interactor.fetchInitialPokemons()
                    
                self.pokemons.append(contentsOf: pokemons)
                self.view?.onFetchPokemons(on: self, with: pokemons)

            } catch {
                
                print("Error: \(error)")
            }
        }
    }
    
    func fetchNextPokemonsOnPokemonListPresenter(on pokemonListView: PokemonListViewControllerType) {
        
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

    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, pokemonCellTappedWith pokemonViewModel: PokemonViewModel) {
        
        print("Navigate to cell at \(pokemonViewModel.name)")
        self.router.showPokemonDetail(with: pokemonViewModel)
    }
    
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, userSearchedForText searchText: String) {

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
    
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, userTappedFavoriteButtonWith pokemonViewModel: PokemonViewModel) {
        
        Task { @MainActor in
            
            Task { @MainActor in
                
                do {
                
                    print("User tried to set favorite status for pokemon \(pokemonViewModel.name)")
                    try await self.interactor.didSetFavoriteStatus(for: pokemonViewModel)
//
                    self.interactor.storeFavoriteStatus(for: pokemonViewModel)
//
//                    let pokemon = self.interactor.pokemon
//                    self.pokemon = pokemon
//                    self.view?.onPokemonFavoriteStatusChanged(with: pokemon.isFavorited)
                    
                } catch {
                    
                    print(error.localizedDescription)
                }
            }
        }
    }
}
