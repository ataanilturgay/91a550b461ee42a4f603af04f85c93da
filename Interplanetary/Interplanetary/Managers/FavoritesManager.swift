//
//  FavoritesManager.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 22.01.2023.
//

import Foundation

protocol FavoritesProtocol: AnyObject {
    
    func update(with station: Station)
    func getFavoriteStations() -> [Station]
    func isFavorited(with station: Station) -> Bool
}

final class FavoritesManager: FavoritesProtocol {
    
    static let shared = FavoritesManager()
    
    private var favoriteStations = [Station]()
    
    func update(with station: Station) {
        let isfavoritesContainsStation = favoriteStations.contains { $0.name == station.name }
        if isfavoritesContainsStation {
            let index = favoriteStations.firstIndex(of: station)
            favoriteStations.remove(at: index!)
        } else {
            favoriteStations.append(station)
        }
    }
    
    func getFavoriteStations() -> [Station] {
        return favoriteStations
    }
    
    func isFavorited(with station: Station) -> Bool {
        let isfavoritesContainsStation = favoriteStations.contains { $0.name == station.name }
        return isfavoritesContainsStation
    }
}
