//
//  PokemonConstants.swift
//  Pokemon
//
//  Created by Miguel Martins on 09/05/2024.
//

import Foundation

enum PokemonConstants {
    
    enum UserDefaults {
        
        static let didSeeOnboarding = "didSeeOnboarding"
    }
}

// MARK: - Layout

extension PokemonConstants {

    enum Layout {
                
        static let defaultLeadingDistance: CGFloat = 16
        static let defaultTrailingDistance: CGFloat = -16
        static let defaultImageRoundedCornerRadius: CGFloat = 20
        static let defaultStackViewSpacing: CGFloat = 16   
        static let defaultTitleLabelHeight: CGFloat = 50
    }
}

// MARK: - PokemonListScreen

extension PokemonConstants {
    
    enum PokemonListScreen {
        
        enum AccessibilityIdentifiers {
            
            static let nextButton = "NextButton"
            static let pokemonCollectionView = "PokemonCollectionView"
        }
        
        enum PokemonCell {
            
            static let identifier = "PokemonCellView"
            
            enum PokemonImage {
                
                static let height: CGFloat = 100
            }
        }
        
        static let title = "Pokémon"
        static let skipLabelText = "Skip"
        static let nextButtonLabelText = "Next"
        
        
    }
}
