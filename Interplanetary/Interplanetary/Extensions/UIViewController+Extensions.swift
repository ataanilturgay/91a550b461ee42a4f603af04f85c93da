//
//  UIViewController+Extensions.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 23.01.2023.
//

import UIKit

extension UIViewController {
    
    func showBasicAlert(with title: String,
                        message: String,
                        okButtonTitle: String? = "Tamam",
                        cancelButtonTitle: String? = nil,
                        okActionCompletion: ((UIAlertAction) -> Void)? = nil,
                        cancelActionCompletion: ((UIAlertAction) -> Void)? = nil,
                        style: UIAlertController.Style) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: style)
        
        alert.addAction(UIAlertAction(title: okButtonTitle,
                                          style: .default,
                                          handler: okActionCompletion))
        
        if cancelButtonTitle != nil {
            alert.addAction(UIAlertAction(title: cancelButtonTitle,
                                          style: .default,
                                          handler: cancelActionCompletion))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
