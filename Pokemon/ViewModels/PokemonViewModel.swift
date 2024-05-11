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
    
    let imageUrl: String?
    let name: String
    let height: Double
    let weight: Double
    let hp: Double
    let attack: Double
    let defense: Double
    let speed: Double
    let types: [String]
    
    var pokemonTypes: [PokemonTypeViewModel] {
        
        var typeAndImages: [PokemonTypeViewModel] = []

        for type in types {
            
            switch type {
                
            case PokemonConstants.PokemonViewModel.Types.fighting.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "hammer.circle.fill", color: .magenta)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.flying.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "bird.circle.fill", color: .accent)
                typeAndImages.append(pokemonType)
             
            case PokemonConstants.PokemonViewModel.Types.poison.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "hourglass.circle.fill", color: .darkGray)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.ground.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "circle.circle.fill", color: .brown)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.rock.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "record.circle.fill", color: .systemGray)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.bug.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "ladybug.circle.fill", color: .black)
                typeAndImages.append(pokemonType)
             
            case PokemonConstants.PokemonViewModel.Types.ghost.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "tornado.circle.fill", color: .systemGray2)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.steel.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "diamond.circle.fill", color: .systemBrown)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.fire.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "fire.circle.fill", color: .systemOrange)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.water.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "drop.circle.fill", color: .systemCyan)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.grass.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "leaf.circle.fill", color: .systemGreen)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.electric.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "bolt.circle.fill", color: .systemYellow)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.psychic.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "hurricane.circle.fill", color: .systemPink)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.ice.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "snowflake.circle.fill", color: .systemTeal)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.dragon.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "eye.circle.fill", color: .systemRed)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.dark.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "cloud.circle.fill", color: .systemIndigo)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.fairy.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "wind.circle.fill", color: .systemBlue)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.stellar.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "star.circle.fill", color: .systemMint)
                typeAndImages.append(pokemonType)
                
            case PokemonConstants.PokemonViewModel.Types.normal.rawValue.capitalized,
                PokemonConstants.PokemonViewModel.Types.unknown.rawValue.capitalized:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "circle.fill", color: .systemTeal)
                typeAndImages.append(pokemonType)

            default:
                let pokemonType = PokemonTypeViewModel(type: type, systemImageName: "circle.fill", color: .systemTeal)
                typeAndImages.append(pokemonType)
            }
        }
        
        return typeAndImages
    }
}
