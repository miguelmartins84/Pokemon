//
//  PokemonCellView.swift
//  Pokemon
//
//  Created by Miguel Martins on 09/05/2024.
//

import UIKit

protocol PokemonCellViewDelegate: AnyObject {
    
    func didTapFavoriteButton(with pokemonViewModel: PokemonViewModel)
}

class PokemonCellView: UICollectionViewCell {
    
    static let identifier = String(describing: PokemonCellView.self)
    
    weak var delegate: PokemonCellViewDelegate?
    
    private var pokemonViewModel: PokemonViewModel?
    
    private var pokemonImageView: AsyncImageView = {
        
        let imageView = AsyncImageView().usingAutoLayout()
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    private var pokemonNamelabel: UILabel = {
        
        let label = UILabel().usingAutoLayout()
        label.font = UIFont.pokemonBoldText
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private var favoriteButton: UIButton = {
        
        let button = UIButton().usingAutoLayout()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.accent.cgColor
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        
        return button
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
        
        self.favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        
        self.addSubviews()
        self.defineConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        
        self.contentView.addSubview(self.favoriteButton)
        self.contentView.addSubview(self.pokemonImageView)
        self.contentView.addSubview(self.pokemonNamelabel)
    }
    
    private func defineConstraints() {
        
        // MARK: - FavoriteButton constraints
        
        NSLayoutConstraint.activate([
            
            self.favoriteButton.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.favoriteButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.favoriteButton.heightAnchor.constraint(equalToConstant: 32),
            self.favoriteButton.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        // MARK: - PokemonImageView constraints
        
        NSLayoutConstraint.activate([
              
            self.pokemonImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 24),
            self.pokemonImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.pokemonImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.pokemonImageView.heightAnchor.constraint(equalToConstant: PokemonConstants.PokemonListScreen.PokemonCell.PokemonImage.height)
        ])
            
        // MARK: - PokemonNameLabel constraints

        NSLayoutConstraint.activate([
                        
            self.pokemonNamelabel.topAnchor.constraint(equalTo: self.pokemonImageView.bottomAnchor, constant: 8),
            self.pokemonNamelabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.pokemonNamelabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.pokemonNamelabel.heightAnchor.constraint(equalToConstant: PokemonConstants.Layout.defaultTitleLabelHeight),
        ])
    }
    
    func configure(with viewModel: PokemonViewModel) async {
        
        self.pokemonViewModel = viewModel
        
        guard let imageUrlString = viewModel.imageUrl,
              let imageURL = URL(string: imageUrlString) else {

            self.pokemonImageView.setImage(image: UIImage(named: "LogoSmall")!)
            self.pokemonNamelabel.text = viewModel.name
            
            return
        }
        
        Task { @MainActor in
            
            await self.pokemonImageView.downloadImage(with: imageURL)
            
            if let image = self.pokemonImageView.image {
            
                self.pokemonImageView.setImage(image: image)
            }
            
            self.pokemonNamelabel.text = viewModel.name
        }        
    }
    
    @objc func didTapFavoriteButton() {
        
        guard let pokemonViewModel = self.pokemonViewModel else {
            
            return
        }
        
        self.delegate?.didTapFavoriteButton(with: pokemonViewModel)
    }
}
