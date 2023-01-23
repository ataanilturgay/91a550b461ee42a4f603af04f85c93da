//
//  BaseViewController.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 18.01.2023.
//

import UIKit

class BaseViewController: UIViewController {
    
    var navigator: Navigator = .default

    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyling()
        syncViewModel()
    }
    
    func applyStyling() {
        // override this method
    }
    
    func syncViewModel() {
        // override this method
    }
}
