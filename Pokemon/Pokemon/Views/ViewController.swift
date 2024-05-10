//
//  UIViewController+Extension.swift
//  Marvel
//
//  Created by Miguel Martins on 09/05/2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.configureView()
        self.addSubviews()
        self.defineConstraints()
    }

    open func configureView() {}
    open func addSubviews() {}
    open func defineConstraints() {}
}
