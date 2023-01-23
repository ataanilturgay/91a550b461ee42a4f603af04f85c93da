//
//  StoryboardFactory.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

import UIKit

public enum StoryboardFactory: String {
    
    case main = "Main"
    
    public func instantiate<VC: UIViewController>(_ viewController: VC.Type = VC.self,
                                                  inBundle bundle: Bundle? = nil) -> VC {
        guard let viewController = UIStoryboard(name: self.rawValue,
                                                bundle: bundle).instantiateViewController(withIdentifier: String(describing: VC.self)) as? VC else {
            fatalError("Couldn't instantiate \(String(describing: VC.self)) from \(self.rawValue)")
        }
        return viewController
    }

    public func instantiateInitial<VC: UIViewController>(_ viewController: VC.Type = VC.self,
                                                         inBundle bundle: Bundle? = nil) -> VC {
        guard let viewController = UIStoryboard(name: self.rawValue,
                                                bundle: bundle).instantiateInitialViewController() as? VC else {
            fatalError("Couldn't instantiate \(String(describing: VC.self)) from \(self.rawValue)")
        }
        return viewController
    }
}
