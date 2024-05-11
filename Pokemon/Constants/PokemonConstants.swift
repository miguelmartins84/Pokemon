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
        static let defaultCornerRadius: CGFloat = 10
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
            static let searchController = "SearchController"
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
        static let placeholderText = "Search for Pokémon"
        static let landscapeWidthDivisor: CGFloat = 5
        static let landscapeHeightDivisor: CGFloat = 2
        static let portraitWidthDivisor: CGFloat = 3
        static let portraitHeightDivisor: CGFloat = 5
        static let collectionViewLineSpacing: CGFloat = 8
        static let collectionViewInsets: CGFloat = 20
    }
}

// MARK: - PokemonViewModel

extension PokemonConstants {
    
    enum PokemonViewModel {
        
        enum Types: String {
            
            case fighting
            case flying
            case poison
            case ground
            case rock
            case bug
            case ghost
            case steel
            case fire
            case water
            case grass
            case electric
            case psychic
            case ice
            case dragon
            case dark
            case fairy
            case stellar
            case normal
            case unknown
        }
    }
}
