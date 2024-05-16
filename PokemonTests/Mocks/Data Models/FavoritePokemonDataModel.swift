//
//  FavoritePokemonDataModel.swift
//  PokemonTests
//
//  Created by Miguel Martins on 16/05/2024.
//

import Foundation
@testable import Pokemon

extension FavoritePokemonDataModel {
    
    static func mock(
        id: Int = 1,
        name: String = "Pikachu"
    ) -> FavoritePokemonDataModel{
        
        FavoritePokemonDataModel(
            id: id,
            name: name
        )
    }
}
