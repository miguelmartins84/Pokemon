//
//  PokemonStatSliderView.swift
//  Pokemon
//
//  Created by Miguel Martins on 14/05/2024.
//

import UIKit

class PokemonStatSliderView: UISlider {
    
    init() {

        super.init(frame: .zero)
        
        self.minimumValue = .zero
        self.maximumValue = PokemonConstants.PokemonStatSlider.maximumValue
        self.isUserInteractionEnabled = false
        self.thumbTintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(statValue: Float,
                   minimumValueImageName: String,
                   maximumValueImageName: String) {
        
        self.value = statValue
        
        if statValue < PokemonConstants.PokemonStatSlider.lowerBound {
            
            self.minimumTrackTintColor = .systemRed
            
        } else if statValue >= PokemonConstants.PokemonStatSlider.lowerBound && statValue < PokemonConstants.PokemonStatSlider.mediumBound {
            
            self.minimumTrackTintColor = .systemYellow

        } else  {
            
            self.minimumTrackTintColor = .systemGreen
        }
        
        self.minimumValueImage = UIImage(systemName: minimumValueImageName)
        self.maximumValueImage = UIImage(systemName: maximumValueImageName)
    }
}
