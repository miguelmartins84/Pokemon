//
//  StatStackView.swift
//  Pokemon
//
//  Created by Miguel Martins on 12/05/2024.
//

import UIKit

class StatStackView: UIStackView {

    private var statLabel: UILabel = {
       
        let titleLabel = UILabel().usingAutoLayout()
        titleLabel.font = UIFont.pokemonBoldText
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center        
        return titleLabel
    }()
    
    private var imageView: UIImageView = {
        
        let imageView = UIImageView().usingAutoLayout()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var statValueLabel: UILabel = {
       
        let titleLabel = UILabel().usingAutoLayout()
        titleLabel.font = UIFont.pokemonRegularText
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        return titleLabel
    }()
    
    init(statLabelText: String) {
        
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        self.contentMode = .center
        self.axis = .vertical
        
        self.statLabel.text = statLabelText
        
        self.addArrangedSubviews([self.statLabel, self.statValueLabel])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(with statValueText: String?, pokemonTypes: [PokemonType]? = nil) {

        self.statValueLabel.text = statValueText
    }
    
    public func configure(with pokemonTypes: [PokemonTypeViewModel]) {
        
        if let pokemonType = pokemonTypes.first,
           let image = UIImage(systemName: pokemonType.systemImageName) {

            self.statValueLabel.addTrailing(image: image.withTintColor(pokemonType.color), text: pokemonType.type.capitalized)
        }
    }
}
