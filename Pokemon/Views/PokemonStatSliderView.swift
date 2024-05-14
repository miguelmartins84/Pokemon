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
        
        self.minimumValue = 0
        self.maximumValue = 200
        
        
        //"timer.circle"
        //"timer.circle.fill"
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
        
        if statValue < 65 {
            
            self.minimumTrackTintColor = .systemRed
            
        } else if statValue >= 65 && statValue < 140 {
            
            self.minimumTrackTintColor = .systemYellow

        } else  {
            
            self.minimumTrackTintColor = .systemGreen
        }
        
        self.minimumValueImage = UIImage(systemName: minimumValueImageName)
        self.maximumValueImage = UIImage(systemName: maximumValueImageName)
    }
}
//
//
//private var slider: UISlider = {
//    
//    let slider = UISlider().usingAutoLayout()
//    slider.minimumValue = 0
//    slider.maximumValue = 100
//    slider.minimumTrackTintColor = .systemBlue
////        slider.maximumTrackTintColor = .systemRed
//    slider.thumbTintColor = .systemGreen
//    slider.value = 15
//
//    return slider
//}()
