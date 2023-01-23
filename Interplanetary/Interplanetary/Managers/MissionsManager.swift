//
//  MissionsManager.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

import Foundation

protocol MissionsProtocol: AnyObject {
    
    func getSpaceshipName() -> String
    func getCurrentStation() -> Station
    func getCurrentUGS() -> Int
    func getCurrentEUS() -> Int
    func getCurrentDS() -> Int
    func getDamageCapacity() -> Int
    func getCurrentPlanetName() -> String
    func currentCoordinates() -> CGPoint
    
    func setSpaceshipName(with value: String)
    func setCurrentStation(with value: Station)
    func setCurrentUGS(with value: Int)
    func setCurrentEUS(with value: Int)
    func setCurrentDS(with value: Int)
    func setCurrentDamageCapacity(with value: Int)
    func setCurrentPlanetName(with value: String)
    func setCurrentCoordinates(x: Int, y: Int)
    
    func reset()
}

final class MissionsManager: MissionsProtocol {
    
    static let shared = MissionsManager()
    
    private var currentStation: Station = Station(name: "Dünya", coordinateX: 0, coordinateY: 0, capacity: 0, stock: 0, need: 0)
    private var spaceshipName: String = ""
    private var currentUGS: Int = 0 // Mevcut/Güncel Uzay Giysi Sayısı
    private var currentEUS: Int = 0 // Mevcut/Güncel Evrensel Uzay Süresi
    private var currentDS: Int = 0 // Mevcut/Güncel Dayanıklılık Süresi
    private var currentDamageCapacity: Int = 100 // Mevcut/Güncel Hasar Kapasitesi
    private var currentPlanetName: String = "Dünya"
    private var currentCoordinateX: CGFloat = 0
    private var currentCoordinateY: CGFloat = 0
    
    /// getters
    func getCurrentStation() -> Station {
        return currentStation
    }
    
    func getSpaceshipName() -> String {
        return spaceshipName
    }
    
    func getCurrentUGS() -> Int {
        return currentUGS
    }
    
    func getCurrentEUS() -> Int {
        return currentEUS
    }
    
    func getCurrentDS() -> Int {
        return currentDS
    }
    
    func getDamageCapacity() -> Int {
        return currentDamageCapacity
    }
    
    func getCurrentPlanetName() -> String {
        return currentPlanetName
    }
    
    func currentCoordinates() -> CGPoint {
        return CGPoint(x: currentCoordinateX, y: currentCoordinateY)
    }
    
    /// setters
    func setCurrentStation(with value: Station) {
        currentStation = value
        setCurrentPlanetName(with: currentStation.name)
        setCurrentCoordinates(x: currentStation.coordinateX, y: currentStation.coordinateY)
    }
    
    func setSpaceshipName(with value: String) {
        spaceshipName = value
    }
    
    func setCurrentUGS(with value: Int) {
        currentUGS = value
    }
    
    func setCurrentEUS(with value: Int) {
        currentEUS = value
    }
    
    func setCurrentDS(with value: Int) {
        currentDS = value
    }
    
    func setCurrentDamageCapacity(with value: Int) {
        currentDamageCapacity = value
    }
    
    func setCurrentPlanetName(with value: String) {
        currentPlanetName = value
    }
    
    func setCurrentCoordinates(x: Int, y: Int) {
        currentCoordinateX = CGFloat(x)
        currentCoordinateY = CGFloat(y)
    }
}

// MARK: - Reset

extension MissionsManager {
    
    func reset() {
        currentStation = Station(name: "Dünya", coordinateX: 0, coordinateY: 0, capacity: 0, stock: 0, need: 0)
        spaceshipName = ""
        currentUGS = 0
        currentEUS = 0
        currentDS = 0
        currentDamageCapacity = 100
        currentPlanetName = "Dünya"
        currentCoordinateX = 0
        currentCoordinateY = 0
    }
}
