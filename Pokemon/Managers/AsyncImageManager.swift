//
//  AsyncImageManager.swift
//  Pokemon
//
//  Created by Miguel Martins on 13/05/2024.
//

import UIKit

enum AsyncImageDownloaderError: Error {
    
    case errorFetchingImage(errorMessage: String)
    case errorConvertingDataToImage
}

protocol AsyncImageManagerType {
    
    var imageCache: NSCache<NSString, UIImage> { get }
    func downloadImageData(from imageURL: URL) async throws -> UIImage
}

class AsyncImageManager {
    
    static let shared: AsyncImageManager = AsyncImageManager()

    let imageCache = NSCache<NSString, UIImage>()
}

extension AsyncImageManager: AsyncImageManagerType {
    
    func downloadImageData(from imageURL: URL) async throws -> UIImage {
        
        let request = URLRequest(url: imageURL)
        
        // Check if image is in Cache if it is return it
        if let imageFromCache = self.imageCache.object(forKey: NSString(string: imageURL.absoluteString)) {
            
            return imageFromCache
        }
                
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            
            throw AsyncImageDownloaderError.errorFetchingImage(errorMessage: "Failed to fetch image from url: \(imageURL.absoluteString)")
        }
        
        guard let image = UIImage(data: data) else {
            
            throw AsyncImageDownloaderError.errorConvertingDataToImage
        }
        
        // Store image on imageCache
        self.imageCache.setObject(image, forKey: NSString(string: imageURL.absoluteString))
        
        return image
    }
}
