//
//  UIStackView+Extension.swift
//  Marvel
//
//  Created by Miguel Martins on 09/05/2024.
//

import UIKit

public extension UIStackView {
    
    func addArrangedSubviews(_ views: [UIView]) {
        
        for view in views { self.addArrangedSubview(view) }
    }
}
