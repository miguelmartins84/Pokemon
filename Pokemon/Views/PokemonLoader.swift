//
//  PokemonLoader.swift
//  Pokemon
//
//  Created by Miguel Martins on 13/05/2024.
//

import UIKit

class PokemonLoader: UIView {
    
    private let loaderImage: UIImageView = {
        
        let loaderImage: UIImageView = UIImageView().usingAutoLayout()
        loaderImage.image = UIImage(named: "pokeball")
        loaderImage.contentMode = .scaleAspectFit

        return loaderImage
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.configureView()
        self.addSubviews()
        self.defineConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        
        
    }
    
    private func addSubviews() {
        
        self.addSubview(self.loaderImage)
    }
    
    private func defineConstraints() {
        
        NSLayoutConstraint.activate([
        
            self.loaderImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.loaderImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.loaderImage.heightAnchor.constraint(equalToConstant: 48),
            self.loaderImage.widthAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func startAnimation() {
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 1.0
        rotation.repeatCount = .infinity
        self.loaderImage.layer.add(rotation, forKey: "spin")
    }


    func stopAnimation() {
        
        self.loaderImage.layer.removeAllAnimations()
    }
}
