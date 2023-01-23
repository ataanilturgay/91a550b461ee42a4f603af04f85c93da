//
//  Navigatable.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

import UIKit
import SafariServices

protocol Navigatable {
    
    var navigator: Navigator! { get set }
}

final class Navigator {

    static let `default` = Navigator()

    enum Scene {
        
        case none
        case landing
        case tabs
    }

    enum Transition {
        
        case root(in: UIWindow, animated: Bool, navigation: Bool = false, animationOptions: UIView.AnimationOptions = .transitionFlipFromLeft)
        case navigation
        case rootNavigation
        case modal(isModalInPresentation: Bool = false)
    }

    private func get(scene: Scene) -> UIViewController? {
        switch scene {
        case .none:
            return nil
        case .landing:
            let vc = StoryboardFactory.main.instantiate(LandingViewController.self)
            return vc
        case .tabs:
            let vc = StoryboardFactory.main.instantiate(MainTabsViewController.self)
            return vc
         }
    }

    func pop(sender: UIViewController?, toRoot: Bool = false, animated: Bool = true) {
        if toRoot {
            sender?.navigationController?.popToRootViewController(animated: animated)
        } else {
            sender?.navigationController?.popViewController(animated: animated)
        }
    }

    func dismiss(sender: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        if let navigationController = sender?.navigationController {
            navigationController.dismiss(animated: animated,
                                         completion: completion)
        } else {
            sender?.dismiss(animated: animated,
                            completion: completion)
        }
    }

    func injectTabBarControllers(in target: UITabBarController) {
        if let children = target.viewControllers {
            for vc in children {
                injectNavigator(in: vc)
            }
        }
    }

    typealias Segue = (scene: Scene,
                       sender: UIViewController?,
                       animated: Bool,
                       transition: Transition)

    static let EmptySegue: Segue = (scene: .none,
                                    sender: nil,
                                    animated: false,
                                    transition: .modal())

    func show(segue: Segue) {
        show(scene: segue.scene,
             sender: segue.sender,
             animated: segue.animated,
             transition: segue.transition)
    }

    // MARK: - invoke a single segue
    func show(scene: Scene, sender: UIViewController?, animated: Bool = true, transition: Transition = .navigation) {
        if let target = get(scene: scene) {
            show(target: target,
                 sender: sender,
                 animated: animated,
                 transition: transition)
        }
    }

    private func show(target: UIViewController, sender: UIViewController?, animated: Bool = true, transition: Transition) {
        injectNavigator(in: target)

        switch transition {
        case .root(in: let window, let isAnimated, let navigation, let animationOptions):
            window.rootViewController = navigation ? UINavigationController(rootViewController: target) : target
            window.makeKeyAndVisible()

            UIView.transition(with: window,
                              duration: isAnimated ? 0.5 : 0.0,
                              options: animationOptions,
                              animations: nil,
                              completion: nil)
            return
        default: break
        }

        guard let sender = sender else {
            fatalError("You need to pass in a sender for .navigation or .modal transitions")
        }

        if let nav = sender as? UINavigationController {
            /// Push Root Controller on Navigation Stack
            nav.pushViewController(target, animated: animated)
            return
        }

        switch transition {
        case .navigation:
            if let nav = sender.navigationController {
                /// Add Controller to Navigation Stack
                nav.pushViewController(target, animated: animated)
            }
        case .rootNavigation:
            if let nav = sender.navigationController {
                /// Set Root ViewController of NavigationController
                nav.setViewControllers([target], animated: animated)
            } else {
                fatalError("must have nav controller to use .rootNavigation")
            }
        case .modal(let isModalInPresentation):
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: target)
                if #available(iOS 13.0, *) {
                    nav.isModalInPresentation = isModalInPresentation
                }
                sender.present(nav, animated: animated, completion: nil)
            }
        default: break
        }
    }

    func injectNavigator(in target: UIViewController) {
        /// View Controller
        if var target = target as? Navigatable {
            target.navigator = self
            return
        }

        /// Navigation Controller
        if let target = target as? UINavigationController, let root = target.viewControllers.first {
            injectNavigator(in: root)
        }
    }
}
