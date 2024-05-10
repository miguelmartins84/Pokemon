//
//  PokemonListRouter.swift
//  Marvel
//
//  Created by Miguel Martins on 09/05/2024.
//

import UIKit

// MARK: - PokemonListRouterType Definition

protocol PokemonListRouterType {
    
    func showPokemonDetail(with: PokemonViewModel)
}

// MARK: - PokemonListRouter

final class PokemonListRouter {
    
    private let navigationController: UINavigationController
    private let moduleFactory: ModuleFactoryType
    
    init(
        navigationController: UINavigationController = UINavigationController(),
        moduleFactory: ModuleFactory = ModuleFactory()
    ) {
        
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
}

// MARK: - PokemonListRouterType Implementation
extension PokemonListRouter: PokemonListRouterType {
    
    func showPokemonDetail(with pokemonViewModel: PokemonViewModel) {
        
        let module = moduleFactory.makePokemonDetail(using: self.navigationController,
                                                     for: pokemonViewModel)
        
        if let viewController = module.assemble() {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
