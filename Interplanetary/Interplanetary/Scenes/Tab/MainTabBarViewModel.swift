//
//  MainTabBarViewModel.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

final class MainTabBarViewModel: BaseViewModel {
    
    override init(provider: APIClient) {
        super.init(provider: provider)
    }

    var tabBarItems: [TabBarItem] {
        return [.stations, .favorites]
    }
    
    func viewModel(for tabBarItem: TabBarItem) -> BaseViewModel {
        switch tabBarItem {
        case .stations:
            let viewModel = HomeViewModel(provider: APIClient(network: NetworkLayer()), name: MissionsManager.shared.getSpaceshipName())
            return viewModel
        case .favorites:
            return BaseViewModel(provider: APIClient(network: NetworkLayer()))
        }
    }
}
