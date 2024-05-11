//
//  AppModule.swift
//  Pokemon
//
//  Created by Miguel Martins on 10/05/2024.
//

import UIKit

protocol AppModule {
    
    func assemble() -> UIViewController?
}

protocol ModuleFactoryType {

    func makePokemonList(using navigationController: UINavigationController) -> PokemonListModule
    func makePokemonDetail(using navigationController: UINavigationController,
                           for pokemon: PokemonViewModel) -> PokemonModule
}

struct ModuleFactory: ModuleFactoryType {
 
    func makePokemonList(using navigationController: UINavigationController = UINavigationController()) -> PokemonListModule {
        
        let router = PokemonListRouter(navigationController: navigationController, moduleFactory: self)
        let view: PokemonListViewController = PokemonListViewController()
        return PokemonListModule(view: view, router: router)
    }
    
    func makePokemonDetail(using navigationController: UINavigationController,
                           for pokemon: PokemonViewModel) -> PokemonModule {
        
        let router = PokemonDetailRouter(navigationController: navigationController, moduleFactory: self)
        let interactor = PokemonDetailInteractor(pokemon: pokemon)
        let presenter = PokemonDetailPresenter(interactor: interactor)
        let view: PokemonDetailViewController = PokemonDetailViewController(presenter: presenter)

        return PokemonModule(view: view, router: router, interactor: interactor, presenter: presenter)
    }
}
