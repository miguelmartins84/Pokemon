//
//  AppLoader.swift
//  Pokemon
//
//  Created by Miguel Martins on 10/05/2024.
//

import UIKit

struct AppLoader {
    
    private let windowScene: UIWindowScene
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let moduleFactory: ModuleFactoryType
    
    init(
        windowScene: UIWindowScene,
        navigationController: UINavigationController = UINavigationController(),
        moduleFactory: ModuleFactoryType = ModuleFactory()
    ) {
        
        self.windowScene = windowScene
        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window.windowScene = windowScene
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    func build() {
        
        let navigationBarAppearance = NavigationAppearanceBuilder.build()
        self.navigationController.navigationBar.prefersLargeTitles = false
        self.navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        self.navigationController.navigationBar.standardAppearance = navigationBarAppearance
        
        let module = moduleFactory.makePokemonList(using: self.navigationController)
        let viewController = module.assemble()
        setRootViewController(viewController)
    }
    
    private func setRootViewController(_ viewController: UIViewController?) {

        self.window.rootViewController = self.navigationController
        
        if let viewController = viewController {
            
            navigationController.pushViewController(viewController, animated: true)
        }
        
        self.window.makeKeyAndVisible()
    }
}
