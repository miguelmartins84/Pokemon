//
//  AsyncImageView.swift
//  Pokemon
//
//  Created by Miguel Martins on 10/05/2024.
//

import UIKit

class AsyncImageView: UIView {
    
    var pokemonImageURL: URL?
    
    private var asyncImageManager: AsyncImageManagerType
    private var loaderView: PokemonLoader = PokemonLoader().usingAutoLayout()
    
    private var imageView: UIImageView = {
        
        let imageView = UIImageView().usingAutoLayout()
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true

        return imageView
    }()
    
    init(
        pokemonImageURL: URL? = nil,
        asyncImageManager: AsyncImageManagerType = AsyncImageManager.shared
    ) {
        self.pokemonImageURL = pokemonImageURL
        self.asyncImageManager = asyncImageManager
        
        super.init(frame: .zero)
        
        self.configureView()
        self.addSubviews()
        self.defineConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        
        self.loaderView.startAnimation()
    }
    
    private func addSubviews() {
        
        self.addSubview(self.loaderView)
        self.addSubview(self.imageView)
    }
    
    private func defineConstraints() {
        
        // MARK: - LoaderView constraints
        
        NSLayoutConstraint.activate([
        
            self.loaderView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.loaderView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.loaderView.heightAnchor.constraint(equalToConstant: 48),
            self.loaderView.widthAnchor.constraint(equalToConstant: 48)
        ])
        
        // MARK: - ImageView constraints
        NSLayoutConstraint.activate([
        
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setImage(image: UIImage) {
  
        self.imageView.image = image
        self.cellStatus(shouldShowLoader: false)
    }
    
    func showLoader() {
        
        cellStatus(shouldShowLoader: true)
    }

    private func cellStatus(shouldShowLoader: Bool) {
        
        if shouldShowLoader {
            
            self.imageView.image = nil
            self.imageView.isHidden = true
            
            self.loaderView.startAnimation()
            self.loaderView.isHidden = false
            
        } else {
            
            self.loaderView.stopAnimation()
            self.loaderView.isHidden = true
            
            self.imageView.isHidden = false
        }
    }
}
