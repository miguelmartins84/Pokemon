//
//  NavigationAppearanceBuilder.swift
//  Pokemon
//
//  Created by Miguel Martins on 09/05/2024.
//

import UIKit

class NavigationAppearanceBuilder {
    
    static func build() -> UINavigationBarAppearance {
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor(named: "BackgroundColor")
        
        let buttonTextAttributes = [
            
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.pokemonRegularText
        ]
        
        let buttonFocusedTextAttributes = [
            
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont.pokemonRegularText
        ]
        
        navigationBarAppearance.buttonAppearance.normal.titleTextAttributes = buttonTextAttributes
        navigationBarAppearance.buttonAppearance.focused.titleTextAttributes = buttonFocusedTextAttributes
        navigationBarAppearance.doneButtonAppearance.normal.titleTextAttributes = buttonTextAttributes
        navigationBarAppearance.doneButtonAppearance.focused.titleTextAttributes = buttonTextAttributes
        
        let titleTextAttributes = [
            
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.pokemonBoldText
        ]
        
        navigationBarAppearance.titleTextAttributes = titleTextAttributes
        
        return navigationBarAppearance
    }
}
