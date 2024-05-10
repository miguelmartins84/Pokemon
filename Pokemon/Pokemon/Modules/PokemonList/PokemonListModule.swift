//
//  PokemonListModule.swift
//  Pokemon
//
//  Created by Miguel Martins on 10/05/2024.
//

import UIKit

final class PokemonListModule {
    
    private var view: PokemonListViewControllerType
    private var router: PokemonListRouterType
    private var interactor: PokemonListInteractorType
    private var presenter: PokemonListPresenterType
        
    init(view: PokemonListViewControllerType = PokemonListViewController(),
         router: PokemonListRouterType = PokemonListRouter(),
         interactor: PokemonListInteractorType = PokemonListInteractor(),
         presenter: PokemonListPresenterType = PokemonListPresenter()) {

        self.view = view
        self.router = router
        self.interactor = interactor
        self.presenter = presenter
    }
    
}

extension PokemonListModule: AppModule {
    
    func assemble() -> UIViewController? {
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        view.presenter = presenter
        
        return view as? UIViewController
    }
}
