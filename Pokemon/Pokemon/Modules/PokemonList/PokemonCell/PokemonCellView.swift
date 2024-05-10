//
//  PokemonCellView.swift
//  Pokemon
//
//  Created by Miguel Martins on 09/05/2024.
//

import UIKit

class PokemonCellView: UICollectionViewCell {
    
    static let identifier = String(describing: PokemonCellView.self)
    
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
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
        
        self.addSubviews()
        self.defineConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        
        self.contentView.addSubview(self.pokemonImageView)
        self.contentView.addSubview(self.pokemonNamelabel)
    }
    
    private func defineConstraints() {
        
        NSLayoutConstraint.activate([
              
            self.pokemonImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: PokemonConstants.Layout.defaultLeadingDistance),
            self.pokemonImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.pokemonImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.pokemonImageView.heightAnchor.constraint(equalToConstant: PokemonConstants.PokemonListScreen.PokemonCell.PokemonImage.height),
                        
            self.pokemonNamelabel.topAnchor.constraint(equalTo: self.pokemonImageView.bottomAnchor, constant: 8),
            self.pokemonNamelabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.pokemonNamelabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.pokemonNamelabel.heightAnchor.constraint(equalToConstant: PokemonConstants.Layout.defaultTitleLabelHeight),
            
            
        ])
    }
    
    func configure(with viewModel: PokemonViewModel) async {
        
        guard let imageURL = URL(string: viewModel.imageUrl) else { return }
        
        Task { @MainActor in
            
            await self.pokemonImageView.downloadImage(with: imageURL)
            self.pokemonImageView.image = self.pokemonImageView.image?.roundedCornerImage(with: PokemonConstants.Layout.defaultImageRoundedCornerRadius)
            self.pokemonNamelabel.text = viewModel.name
        }        
    }
}
