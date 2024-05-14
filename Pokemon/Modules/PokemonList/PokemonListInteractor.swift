//
//  PokemonListInteractor.swift
//  Marvel
//
//  Created by Miguel Martins on 04/05/2024.
//

import UIKit

// MARK: - PokemonListInteractorType

protocol PokemonListInteractorType {
    
    var presenter: PokemonListPresenterType? { get set }
    
    func fetchInitialPokemons() async throws -> [Pokemon]
    func fetchNextPokemons() async throws -> [Pokemon]
    func fetchPokemons(withNamesStartingWith searchText: String) async throws -> [Pokemon]
    func fetchFavoriteStatus(pokemonId: Int) -> Bool
    func didSetFavoriteStatus(pokemonId: Int, pokemonName: String) async throws -> Bool
    func storeFavoriteStatus(pokemonId: Int, pokemonName: String)
    func fetchImages(of imageUrlModels: [PokemonImageUrlModel]) async throws -> [PokemonImageModel]
}

// MARK: - PokemonListInteractor

final class PokemonListInteractor {
    
    weak var presenter: PokemonListPresenterType?
    
    private var pokemonManager: PokemonManagerType    
    
    init(pokemonManager: PokemonManagerType = PokemonManager.shared) {
        
        self.pokemonManager = pokemonManager
    }
}

// MARK: - PokemonListInteractorType implementation

extension PokemonListInteractor: PokemonListInteractorType {
    
    func fetchInitialPokemons() async throws -> [Pokemon] {
        
        return try await self.pokemonManager.fetchInitialPokemons()
    }
    
    func fetchNextPokemons() async throws -> [Pokemon] {
        
        return try await self.pokemonManager.fetchPokemons()
    }
    
    func fetchPokemons(withNamesStartingWith searchText: String) async throws -> [Pokemon] {
        
        return try await self.pokemonManager.fetchPokemons(withNamesStartingWith: searchText)
    }
    
    func fetchFavoriteStatus(pokemonId: Int) -> Bool {
        
        self.pokemonManager.fetchFavoriteStatus(for: pokemonId)
    }
    
    func didSetFavoriteStatus(pokemonId: Int, pokemonName: String) async throws -> Bool {
        
        do {
            let favoriteStatus = self.pokemonManager.fetchFavoriteStatus(for: pokemonId)
            return try await self.pokemonManager.didChangePokemonFavoriteStatus(with: pokemonId, pokemonName: pokemonName, isFavorite: !favoriteStatus)
            
        } catch {
            
            throw PokemonNetworkError.failedToAddPokemon(with: error)
        }
    }
    
    func storeFavoriteStatus(pokemonId: Int, pokemonName: String) {
        
        let favoriteStatus = self.pokemonManager.fetchFavoriteStatus(for: pokemonId)
        self.pokemonManager.didStoreFavoriteStatus(with: pokemonId, pokemonName: pokemonName, isFavorite: !favoriteStatus)
    }
    
    func fetchImages(of imageUrlModels: [PokemonImageUrlModel]) async throws -> [PokemonImageModel] {
        
        return try await withThrowingTaskGroup(of: PokemonImageModel.self) { group in
            
            for imageUrlModel in imageUrlModels {
                
                group.addTask {
                    
                    let image = try await AsyncImageManager.shared.downloadImageData(from: imageUrlModel.imageUrl)
                    return PokemonImageModel(row: imageUrlModel.row, image: image)
                }
            }
            
            var fetchedImages: [PokemonImageModel] = []
            
            for try await fetchedImageModel in group {

                let pokemonImageModel = PokemonImageModel(row: fetchedImageModel.row, image: fetchedImageModel.image)
                fetchedImages.append(pokemonImageModel)
            }
            
            return fetchedImages
        }
    }
}
