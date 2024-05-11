//
//  PokemonDetailRouter.swift
//  Pokemon
//
//  Created by Miguel Martins on 10/05/2024.
//

import UIKit

// MARK: - PokemonDetailRouterType Definition

protocol PokemonDetailRouterType {}

// MARK: - PokemonDetailRouter

final class PokemonDetailRouter {
    
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

// MARK: - PokemonRouterType Implementation
extension PokemonDetailRouter: PokemonDetailRouterType {}
