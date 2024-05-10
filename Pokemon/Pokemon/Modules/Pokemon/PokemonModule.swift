//
//  PokemonModule.swift
//  Pokemon
//
//  Created by Miguel Martins on 10/05/2024.
//

import UIKit

final class PokemonModule {
    
    private var view: PokemonDetailViewControllerType
    private var router: PokemonDetailRouterType
    private var interactor: PokemonDetailInteractorType
    private var presenter: PokemonDetailPresenterType
        
    init(view: PokemonDetailViewControllerType,
         router: PokemonDetailRouterType = PokemonDetailRouter(),
         interactor: PokemonDetailInteractorType,
         presenter: PokemonDetailPresenterType) {

        self.view = view
        self.router = router
        self.interactor = interactor
        self.presenter = presenter
    }
    
}

extension PokemonModule: AppModule {
    
    func assemble() -> UIViewController? {
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        view.presenter = presenter
        
        return view as? UIViewController
    }
}
