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
    
    func onPokemonListInteractorFetchInitialPokemons(on pokemonListPresenter: PokemonListPresenterType) async throws -> [Pokemon]
    func onPokemonListInteractorfetchNextPokemons(on pokemonListPresenter: PokemonListPresenterType) async throws -> [Pokemon]
    func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, didFetchPokemonsWithNamesStartingWith searchText: String) async throws -> [Pokemon]
    func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, didfetchFavoriteStatusWith pokemonId: Int) -> Bool
    func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, didSetFavoriteStatusWith pokemonId: Int, pokemonName: String) async throws -> Bool
    func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, didStoreFavoriteStatusWith pokemonId: Int, pokemonName: String)
    func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, fetchImagesFor imageUrlModels: [PokemonImageUrlModel]) async throws -> [PokemonImageModel]
}

// MARK: - PokemonListInteractor

final class PokemonListInteractor {
    
    weak var presenter: PokemonListPresenterType?
    
    private var pokemonManager: PokemonManagerType
    private var asyncImageManager: AsyncImageManagerType
    
    init(
        pokemonManager: PokemonManagerType = PokemonManager.shared,
        asyncImageManager: AsyncImageManagerType = AsyncImageManager.shared
    ) {
        
        self.asyncImageManager = asyncImageManager
        self.pokemonManager = pokemonManager
        self.pokemonManager.delegate = self
    }
}

// MARK: - PokemonListInteractorType implementation

extension PokemonListInteractor: PokemonListInteractorType {

    func onPokemonListInteractorFetchInitialPokemons(on pokemonListPresenter: PokemonListPresenterType) async throws -> [Pokemon] {
        
        return try await self.pokemonManager.fetchInitialPokemons()
    }
    
    func onPokemonListInteractorfetchNextPokemons(on pokemonListPresenter: PokemonListPresenterType) async throws -> [Pokemon] {
        
        return try await self.pokemonManager.fetchPokemons()
    }
    
    func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, didFetchPokemonsWithNamesStartingWith searchText: String) async throws -> [Pokemon] {
        
        return try await self.pokemonManager.fetchPokemons(withNamesStartingWith: searchText)
    }
    
    func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, didfetchFavoriteStatusWith pokemonId: Int) -> Bool {
        
        self.pokemonManager.fetchFavoriteStatus(for: pokemonId)
    }
    
    func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, didSetFavoriteStatusWith pokemonId: Int, pokemonName: String) async throws -> Bool {
        
        do {
            let favoriteStatus = self.pokemonManager.fetchFavoriteStatus(for: pokemonId)
            return try await self.pokemonManager.didChangePokemonFavoriteStatus(with: pokemonId, pokemonName: pokemonName, isFavorite: !favoriteStatus)
            
        } catch {
            
            throw PokemonNetworkError.failedToAddPokemon(with: error)
        }
    }
    
    func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, didStoreFavoriteStatusWith pokemonId: Int, pokemonName: String) {
        
        let favoriteStatus = self.pokemonManager.fetchFavoriteStatus(for: pokemonId)
        self.pokemonManager.didStoreFavoriteStatus(with: pokemonId, pokemonName: pokemonName, isFavorite: !favoriteStatus)
    }
    
    func onPokemonListInteractor(on pokemonListPresenter: PokemonListPresenterType, fetchImagesFor imageUrlModels: [PokemonImageUrlModel]) async throws -> [PokemonImageModel] {
        
        return try await withThrowingTaskGroup(of: PokemonImageModel.self) { group in
            
            for imageUrlModel in imageUrlModels {
                
                group.addTask {
                    
                    let image = try await self.asyncImageManager.downloadImageData(from: imageUrlModel.imageUrl)
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

// MARK: - PokemonManagerDelegateType implementation

extension PokemonListInteractor: PokemonManagerDelegateType {
    
    func onPokemonManager(on pokemonManager: any PokemonManagerType, didChangeFavoriteStatusOfPokemonWith pokemonId: Int, favoriteStatus: Bool) {
        
        self.presenter?.onPokemonListInteractor(on: self, didChangeFavoriteStatusOf: pokemonId)
    }
}
