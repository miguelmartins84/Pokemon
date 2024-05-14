//
//  FavoritePokemonsDataManager.swift
//  Pokemon
//
//  Created by Miguel Martins on 13/05/2024.
//

import RealmSwift


// MARK: - FavoritePokemonsDataManagerType definition

protocol FavoritePokemonsDataManagerType: AnyObject {
    
    func getFavorites() -> [FavoritePokemonDataModel]
    func addToFavorites(favoritePokemonDataModel: FavoritePokemonDataModel)
    func removeFromFavorites(favoritePokemonDataModel: FavoritePokemonDataModel)    
}

// MARK: - FavoritePokemonsDataManager

class FavoritePokemonsDataManager {
    
    static let shared: FavoritePokemonsDataManagerType = FavoritePokemonsDataManager()
    
    private var realm: Realm? = nil
    
    init() {
        
        let realmDefaultConfiguration = Realm.Configuration.defaultConfiguration
        
        guard let fileURL = realmDefaultConfiguration.fileURL else {
            
            fatalError("Realm file not found")
        }
        
        do {
            
            print("Realm started with file on \(fileURL)")
            self.realm = try Realm()

        } catch {
            
            print("Error initialising new realm: \(error)")
        }
    }
}

// MARK: - FavoritePokemonsDataManagerType implementation

extension FavoritePokemonsDataManager: FavoritePokemonsDataManagerType {
    
    func getFavorites() -> [FavoritePokemonDataModel] {
        
        guard let realm = self.realm else {
            
            return []
        }
 
        let results = Array(realm.objects(FavoritePokemonDataModel.self))
        return results
    }
    
    func addToFavorites(favoritePokemonDataModel: FavoritePokemonDataModel) {
        
        guard let realm = self.realm else {
            
            return
        }
        
        do {
                        
            try realm.write {
                
                realm.add(favoritePokemonDataModel)
            }
        } catch {
            
            print("Error storing favorite pokemon \(favoritePokemonDataModel.name): \(error.localizedDescription)")
        }
    }
    
    func removeFromFavorites(favoritePokemonDataModel: FavoritePokemonDataModel) {
        
        guard let realm = self.realm else {
            
            return
        }
        
        do {
            
            let favoritePokemon = Array(realm.objects(FavoritePokemonDataModel.self).filter("id=%@",favoritePokemonDataModel.id))
            
            try realm.write {
                
                realm.delete(favoritePokemon)
            }
            
        } catch {
            
            print("Error storing favorite pokemon \(favoritePokemonDataModel.name): \(error.localizedDescription)")
        }
    }
}
