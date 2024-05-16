//
//  PokemonListPresenter.swift
//  Marvel
//
//  Created by Miguel Martins on 04/05/2024.
//

import UIKit

// MARK: - PokemonListPresenterType

protocol PokemonListPresenterType: AnyObject {
    
    var view: PokemonListViewControllerType? { get set }
    var interactor: PokemonListInteractorType { get set }
    var router: PokemonListRouterType { get set }
    
    var fetchedPokemonViewModels: [PokemonViewModel] { get }
    var refinedPokemonViewModels: [PokemonViewModel] { get }

    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType)
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, pokemonCellTappedWith pokemonViewModel: PokemonViewModel)
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, userSearchedForText searchText: String)
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, userTappedFavoriteButtonWith: PokemonViewModel)
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, fetchPokemonViewModelFor row: Int) -> PokemonViewModel?
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, fetchImagesfor rows: [Int], isInitialFetch: Bool) async
    func onPokemonListPresenterUpdateListOfFavoritePokemons(on pokemonListView: PokemonListViewControllerType)
    func onPokemonListPresenterFetchNextPokemons(on pokemonListView: PokemonListViewControllerType)
    func onPokemonListPresenterFetchNumberOfPokemons(on pokemonListView: PokemonListViewControllerType) -> Int
    
    func onPokemonListInteractor(on pokemoListInteractor: PokemonListInteractorType, didChangeFavoriteStatusOf pokemonId: Int)
}

// MARK: - PokemonListPresenter

final class PokemonListPresenter {
    
    weak var view: PokemonListViewControllerType?
    var interactor: PokemonListInteractorType
    var router: PokemonListRouterType
    
    var fetchedPokemonViewModels: [PokemonViewModel] = []
    var refinedPokemonViewModels: [PokemonViewModel] = []
    var fetchedImages: [Int: UIImage] = [:]
    private var isSearchContext: Bool = false
    private var isInitialSearch: Bool = true
    
    private var taskHandler: Task<Void, Never>?
    
    init(
        view: PokemonListViewControllerType? = nil,
        interactor: PokemonListInteractorType = PokemonListInteractor(),
        router: PokemonListRouterType = PokemonListRouter()
    ) {

        self.interactor = interactor
        self.router = router
    }
}

// MARK: - PokemonListPresenterType implementation

extension PokemonListPresenter: PokemonListPresenterType {
    
    func onPokemonListPresenterUpdateListOfFavoritePokemons(on pokemonListView: PokemonListViewControllerType) {
        
        guard self.isInitialSearch == false else {
            
            return
        }
        
        let favoriteIds = self.interactor.onPokemonListInteractorFetchPokemonsFavoriteStatus(on: self)
        
        self.clearFavoriteStatus(with: favoriteIds)
        
        favoriteIds.forEach { favoriteId in
            
            self.updateFavoriteStatusForPokemonViewModel(with: favoriteId, favoriteStatus: true)
        }
        
        self.view?.onPokemonListPresenterDidUpdatePokemons(on: self)
    }

    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType) {
        
        self.view = pokemonListView
        
        Task { @MainActor in
            
            do {
                
                /// 1. Fetch initial batch of pokemons
                let pokemons = try await self.interactor.onPokemonListInteractorFetchInitialPokemons(on: self)
                
                /// 2. Append pokemon view models to the auxiliary arrays and set their favorite status according to the realm database
                let pokemonViewModels = self.appendPokemonViewModels(from: pokemons, isInitialFetch: self.isInitialSearch)
                
                /// 3. Fetch the initial batch of images for the number of view models
                let indexes = Array(0 ... pokemonViewModels.count - 1)
                await self.fetchImages(for: indexes, isInitialFetch: self.isInitialSearch)
                
                self.isInitialSearch = false

                /// 4. Inform the view to reload the collection view
                self.view?.onPokemonListPresenterDidUpdatePokemons(on: self)

            } catch {
                
                print("Error: \(error)")
            }
        }
    }

    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, pokemonCellTappedWith pokemonViewModel: PokemonViewModel) {
        
        print("Navigate to cell at \(pokemonViewModel.name)")        
        self.router.onPokemonListRouter(on: self,
                                        didTapShowPokemonDetailWith: pokemonViewModel)
    }
    
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, userSearchedForText searchText: String) {

        if let taskHandler = self.taskHandler {
            
            taskHandler.cancel()
        }
        
        self.taskHandler = Task { @MainActor in
                        
            self.isSearchContext = searchText.isEmpty == false
            self.refinedPokemonViewModels = []
            
            do {
                
                /// 1. Fetch batch of pokemon according to the typed text
                let pokemons = try await self.interactor.onPokemonListInteractor(on: self,
                                                                                 didFetchPokemonsWithNamesStartingWith: searchText)
                
                /// 2. Append pokemon view models to the auxiliary arrays and set their favorite status according to the database
                let _ = self.appendPokemonViewModels(from: pokemons, isInitialFetch: false)
                
                if self.refinedPokemonViewModels.count > 0 {
                    
                    /// 3. Fetch the  batch of images for the number of view models
                    let indexes = Array(0 ... self.refinedPokemonViewModels.count - 1)
                    await self.fetchImages(for: indexes, isInitialFetch: true)
                }
                
                /// 4. Inform the view to reload the collection view
                self.view?.onPokemonListPresenterDidUpdatePokemons(on: self)
                
            } catch {
                
                print("Error: \(error)")
            }
        }
    }
    
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, userTappedFavoriteButtonWith pokemonViewModel: PokemonViewModel) {
        
        Task { @MainActor in
                
            do {

                /// 1. Set Favorite Status of pokemon view model on interactor
                let favoriteStatus = try await self.interactor.onPokemonListInteractor(on: self, 
                                                                                       didSetFavoriteStatusWith: pokemonViewModel.id, 
                                                                                       pokemonName: pokemonViewModel.name)

                /// 2. Invoke interactor to store the favorite status on the database
                self.interactor.onPokemonListInteractor(on: self,
                                                        didStoreFavoriteStatusWith: pokemonViewModel.id,
                                                        pokemonName: pokemonViewModel.name)
                
                /// 3. Update favorite status for the pokemon view models
                self.updateFavoriteStatusForPokemonViewModel(with: pokemonViewModel.id, favoriteStatus: favoriteStatus)
                
                /// 4. Inform the view to reload the collection view
                self.view?.onPokemonListPresenterDidUpdatePokemons(on: self)

            } catch {
                
                print(error.localizedDescription)
            }
        }
    }
    
    func onPokemonListPresenter(on pokemonListView: PokemonListViewControllerType, fetchPokemonViewModelFor row: Int) -> PokemonViewModel? {
        
        if self.isSearchContext {
            
            if row < self.refinedPokemonViewModels.count {
                
                return self.refinedPokemonViewModels[row]
            }

        } else {
            
            if row < self.fetchedPokemonViewModels.count {
                
                return self.fetchedPokemonViewModels[row]
            }
        }
        
        return nil
    }
    
    func onPokemonListPresenterFetchNextPokemons(on pokemonListView: PokemonListViewControllerType) {
        
        Task { @MainActor in
            
            do {
                    
                /// 1. Invoke interactor to fetch next batch of pokemons
                let pokemons = try await self.interactor.onPokemonListInteractorfetchNextPokemons(on: self)
                
                /// 2. Append pokemon view models to the auxiliary arrays and set their favorite status according to the database
                let _ = self.appendPokemonViewModels(from: pokemons, isInitialFetch: false)

                /// 3. Inform the view to reload the collection view
                self.view?.onPokemonListPresenterDidUpdatePokemons(on: self)

            } catch {
                
                print("Error fetching next batch of pokemons: \(error)")
            }
        }
    }
    
    func onPokemonListPresenterFetchNumberOfPokemons(on pokemonListView: any PokemonListViewControllerType) -> Int {
        
        if self.isSearchContext {
            
            return self.refinedPokemonViewModels.count
            
        } else {
            
            return self.fetchedPokemonViewModels.count
        }
    }
    
    func onPokemonListPresenter(on pokemonListView: any PokemonListViewControllerType, fetchImagesfor rows: [Int], isInitialFetch: Bool) async {
        
        await self.fetchImages(for: rows, isInitialFetch: isInitialFetch)
    }
    
    func onPokemonListInteractor(on pokemoListInteractor: PokemonListInteractorType, didChangeFavoriteStatusOf pokemonId: Int) {
        
        let favoriteStatus = self.interactor.onPokemonListInteractor(on: self,
                                                                     didfetchFavoriteStatusWith: pokemonId)
        self.updateFavoriteStatusForPokemonViewModel(with: pokemonId, favoriteStatus: favoriteStatus)
    }
}

// MARK: - Private Methods

extension PokemonListPresenter {
    
    func fetchImages(for rows: [Int], isInitialFetch: Bool = false) async {
                        
        var pokemonImageUrls: [PokemonImageUrlModel] = []
        
        /// 1. Cycle through array of rows to fetch images for
        
        for row in rows {
            
            /// 2. Check if initial fetch of images ( no condition needs to be obeyed in this case we can just fetch)
            
            if isInitialFetch {

                /// 2.1.1 Fetch pokemonViewModel from refined or regular fetch array
                let pokemonViewModel = self.isSearchContext ? self.refinedPokemonViewModels[row] : self.fetchedPokemonViewModels[row]

                /// 2.1.2 Check if pokemonViewModel has imageUrl and if so append it to the array of pokemonImageUrls to be fetched
                if let imageUrlString = pokemonViewModel.imageUrl,
                   let imageUrl = URL(string: imageUrlString) {
                    
                    let pokemonUrlModel = PokemonImageUrlModel(row: row, imageUrl: imageUrl)
                    pokemonImageUrls.append(pokemonUrlModel)
                }
                
            } else if row >= self.fetchedPokemonViewModels.count - self.fetchedPokemonViewModels.count / 2 {
                
                /// 2.2.1 Fetch pokemonViewModel from refined or regular fetch array if the row has not been previously fetched
                let pokemonViewModel = self.isSearchContext ? self.refinedPokemonViewModels[row] : self.fetchedPokemonViewModels[row]
                
                /// 2.2.2 Check if pokemonViewModel has imageUrl and if so append it to the array of pokemonImageUrls to be fetched
                if let imageUrlString = pokemonViewModel.imageUrl,
                   let imageUrl = URL(string: imageUrlString) {
                    
                    let pokemonUrlModel = PokemonImageUrlModel(row: row, imageUrl: imageUrl)
                    pokemonImageUrls.append(pokemonUrlModel)
                }
            }
        }
        
        /// 3. Check if there are imageUrls to fetch otherwise returnCheck if pokemonViewModel has imageUrl and if so append it to the array of pokemonImageUrls to be fetched
        guard pokemonImageUrls.isEmpty == false else { return}
        
        do {

            /// 4. Fetch images from the interactor
            let imageModels = try await self.interactor.onPokemonListInteractor(on: self,
                                                                                fetchImagesFor: pokemonImageUrls)
            
            /// 5. Cycle through the image modes and edit the appropriate pokemon view models with the corresponding images
            for imageModel in imageModels {
                
                if self.isSearchContext {
                    
                    self.refinedPokemonViewModels[imageModel.row].setImage(with: imageModel.image)

                } else {
                    self.fetchedPokemonViewModels[imageModel.row].setImage(with: imageModel.image)
                }
            }
            
            /// 6. Inform the view to reload the collection view

            Task { @MainActor in
            
                self.view?.onPokemonListPresenterDidUpdatePokemons(on: self)
            }
            
        } catch {
            
            print("Error fetching images: \(error)")
        }
    }
    
    func appendPokemonViewModels(from pokemons: [Pokemon], isInitialFetch: Bool) -> [PokemonViewModel] {
        
        var pokemonViewModels: [PokemonViewModel] = []
        
        /// 1. Cycle through the pokemon data models
        for pokemon in pokemons {
            
            /// 2. Create the corresponding pokemon view models
            var pokemonViewModel = PokemonViewModelFactory.createPokemonViewModel(from: pokemon)
            
            /// 3. Set favorite status of the pokemon view models according to the values stored in the database
            
            let favoriteStatus = self.interactor.onPokemonListInteractor(on: self,
                                                                         didfetchFavoriteStatusWith: pokemonViewModel.id)
            pokemonViewModel.setFavoriteStatus(isFavorited: favoriteStatus)
            
            /// 4. Append to the pokemon view models array
            pokemonViewModels.append(pokemonViewModel)
        }
        
        /// 5. Append to the auxiliary arrays
        
        if self.isSearchContext {
            
            self.refinedPokemonViewModels.append(contentsOf: pokemonViewModels)

        } else {
            
            self.fetchedPokemonViewModels.append(contentsOf: pokemonViewModels)
        }
        
        /// 6. Return the corresponding array
        
        return pokemonViewModels
    }
    
    func updateFavoriteStatusForPokemonViewModel(with id: Int, favoriteStatus: Bool) {
        
        if let row = self.fetchedPokemonViewModels.firstIndex(where: { $0.id == id }) {
            
            self.fetchedPokemonViewModels[row].setFavoriteStatus(isFavorited: favoriteStatus)
        }
        
        if let row = self.refinedPokemonViewModels.firstIndex(where: { $0.id == id }) {

            self.fetchedPokemonViewModels[row].setFavoriteStatus(isFavorited: favoriteStatus)
        }
    }
    
    func clearFavoriteStatus(with ids: Set<Int>) {
        
        let favoritePokemons = self.fetchedPokemonViewModels.filter { $0.isFavorited }
        
        let pokemonsToRemove = favoritePokemons.filter { !ids.contains($0.id) }
        
        pokemonsToRemove.forEach { pokemonViewModel in

            self.updateFavoriteStatusForPokemonViewModel(with: pokemonViewModel.id, favoriteStatus: false)
        }
    }
}
