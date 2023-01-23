//
//  UITextField+Extensions.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 21.01.2023.
//

import UIKit

extension UITextField {
    
    func setLeftPaddingPoints(_ value: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ value: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
