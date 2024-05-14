//
//  PokemonViewModel.swift
//  Marvel
//
//  Created by Miguel Martins on 04/05/2024.
//

import UIKit

struct PokemonTypeViewModel {
    
    let type: String
    let systemImageName: String
    let color: UIColor
}

struct PokemonViewModel {
    
    let id: Int
    let imageUrl: String?
    let name: String
    let height: Double
    let weight: Double
    let hp: Double
    let attack: Double
    let defense: Double
    let speed: Double
    let types: [String]
    private(set) var image: UIImage?
    private(set) var isFavorited: Bool = false
    
    mutating func setFavoriteStatus(isFavorited: Bool) {
        
        self.isFavorited = isFavorited
    }
    
    mutating func setImage(with image: UIImage) {
        
        self.image = image
    }
    
    var pokemonTypes: [PokemonTypeViewModel] {
        
        var typeAndImages: [PokemonTypeViewModel] = []

        for type in types {
            
            switch type {
                
            case PokemonConstants.PokemonViewModel.Types.fighting.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.fighting.rawValue,
                                                       color: .magenta)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.flying.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.flying.rawValue,
                                                       color: .accent)
                typeAndImages.append(pokemonType)
             
            case PokemonConstants.PokemonViewModel.Types.poison.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.poison.rawValue,
                                                       color: .darkGray)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.ground.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.ground.rawValue,
                                                       color: .brown)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.rock.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type,
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.rock.rawValue,
                                                       color: .systemGray)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.bug.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type,
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.bug.rawValue,
                                                       color: .black)
                typeAndImages.append(pokemonType)
             
            case PokemonConstants.PokemonViewModel.Types.ghost.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.ghost.rawValue,
                                                       color: .systemGray2)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.steel.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.steel.rawValue,
                                                       color: .systemBrown)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.fire.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.fire.rawValue,
                                                       color: .systemOrange)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.water.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.water.rawValue,
                                                       color: .systemCyan)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.grass.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.grass.rawValue,
                                                       color: .systemGreen)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.electric.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName:PokemonConstants.PokemonViewModel.Images.electric.rawValue,
                                                       color: .systemYellow)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.psychic.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.psychic.rawValue,
                                                       color: .systemPink)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.ice.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.ice.rawValue,
                                                       color: .systemTeal)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.dragon.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.dragon.rawValue,
                                                       color: .systemRed)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.dark.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.dark.rawValue,
                                                       color: .systemIndigo)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.fairy.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.fairy.rawValue,
                                                       color: .systemBlue)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.stellar.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.stellar.rawValue,
                                                       color: .systemMint)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.normal.rawValue.capitalized,
                PokemonConstants.PokemonViewModel.Types.unknown.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.normal.rawValue,
                                                       color: .systemTeal)
                typeAndImages.append(pokemonType)

            default:
                let pokemonType = PokemonTypeViewModel(type: type, 
                                                       systemImageName: PokemonConstants.PokemonViewModel.Images.normal.rawValue,
                                                       color: .systemTeal)
                typeAndImages.append(pokemonType)
            }
        }
        
        return typeAndImages
    }
}
