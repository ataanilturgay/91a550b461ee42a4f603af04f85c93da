//
//  MainTabsViewController.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

import UIKit

enum TabBarItem {
    
    case stations, favorites
    
    var image: UIImage {
        switch self {
            case .stations: return UIImage(named: "station")!
            case .favorites: return UIImage(named: "favorites-empty")!
        }
    }
    
    var tabBarTitle: String {
        switch self {
            case .stations: return "İstasyonlar"
            case .favorites: return "Favoriler"
        }
    }
    
    func controller(with viewModel: BaseViewModel) -> UIViewController {
        
        switch self {
        case .stations:
            let vc = StoryboardFactory.main.instantiate(HomeViewController.self)
            
            vc.viewModel = (viewModel as? HomeViewModel)
            vc.tabBarItem.image = image
            vc.tabBarItem.title = tabBarTitle
            vc.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
            
            return UINavigationController(rootViewController: vc)
            
        case .favorites:
            let vc = StoryboardFactory.main.instantiate(FavoritesViewController.self)
            
            vc.tabBarItem.image = image
            vc.tabBarItem.title = tabBarTitle
            vc.title = "Favorites"
            vc.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)

            return UINavigationController(rootViewController: vc)
        }
    }
}

class MainTabsViewController: UITabBarController, Navigatable {
    
    var navigator: Navigator!
    
    private var viewModel = {
        return MainTabBarViewModel(provider: APIClient(network: NetworkLayer()))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        syncViewModel()
        applyStyling()
    }
    
    private func syncViewModel() {
        
        let controllers = viewModel.tabBarItems.map { $0.controller(with: self.viewModel.viewModel(for: $0)) }
        self.setViewControllers(controllers, animated: false)
        self.navigator.injectTabBarControllers(in: self)
    }
    
    private func applyStyling() {
        self.tabBar.tintColor = .textColor
        self.tabBar.barTintColor = .textColor
    }
}
