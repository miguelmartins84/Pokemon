//
//  UILabel+Extension.swift
//  Pokemon
//
//  Created by Miguel Martins on 13/05/2024.
//

import UIKit

extension UILabel {
    
    func addTrailing(image: UIImage, text: String) {
        
        let attachment = NSTextAttachment()
        attachment.image = image
        
        let attachmentString = NSAttributedString(attachment: attachment)
        let string = NSMutableAttributedString(string: text, attributes: [:])
        
        string.append(attachmentString)
        self.attributedText = string
    }
}
