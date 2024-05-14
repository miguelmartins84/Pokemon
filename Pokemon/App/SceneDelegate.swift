//
//  SceneDelegate.swift
//  Pokemon
//
//  Created by Miguel Martins on 09/05/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var loader: AppLoader?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }

        self.loader = AppLoader(windowScene: windowScene)
        self.loader?.build()
    }
}

