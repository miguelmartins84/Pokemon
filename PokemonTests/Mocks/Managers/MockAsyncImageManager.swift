//
//  MockAsyncImageManager.swift
//  PokemonTests
//
//  Created by Miguel Martins on 15/05/2024.
//

import UIKit
@testable import Pokemon

enum MockAsyncImageManagerError: Error {
    
    case imageNotFound
}

class MockAsyncImageManager: AsyncImageManagerType {
    
    var imageCache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()
    
    func downloadImageData(from imageURL: URL) async throws -> UIImage {
        
        if let image = UIImage(named: "PokemonLogo") {
            
            return image
        }
        
        throw MockAsyncImageManagerError.imageNotFound
    }
}
