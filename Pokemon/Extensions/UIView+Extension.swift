//
//  UIView+Extension.swift
//  Marvel
//
//  Created by Miguel Martins on 09/05/2024.
//

import UIKit

public extension UIView {
    
    /// Creates an instance of a UIView (or subclass) with translatesAutoresizingMaskIntoConstraints set to false.
    static func usingAutoLayout() -> Self {
        
        let anyUIView = self.init()
        anyUIView.translatesAutoresizingMaskIntoConstraints = false
        
        return anyUIView
    }
    
    @discardableResult
    func usingAutoLayout() -> Self {

        self.translatesAutoresizingMaskIntoConstraints = false

        return self
    }
}
