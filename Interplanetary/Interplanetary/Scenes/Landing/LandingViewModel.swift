//
//  LandingViewModel.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 18.01.2023.
//

protocol Landing: AnyObject {
    
    var name: String { get set }
    var capacity: Int { get set }
    var durability: Int { get set }
    var speed: Int { get set }
    var totalPoints: Int { get set }
    var remainingPoints: Int { get set }

    func calculateTotalPoints()
    func configureSpaceship()
}

final class LandingViewModel: Landing {
    
    var name: String = ""
    var capacity: Int = 0
    var durability: Int = 0
    var speed: Int = 0
    var totalPoints: Int = 15
    var remainingPoints: Int = 0

    public var calculatedTotalPointsFull = { () -> Void in }
    public var calculatedTotalPointsRemainingPoints = { (remaining: Int) -> Void in }
    public var calculatedTotalPointsError = { (text: String) -> Void in }

    func calculateTotalPoints() {
        let currentPoints = capacity + durability + speed
        remainingPoints = totalPoints - currentPoints
        
        if remainingPoints == 0 {
            calculatedTotalPointsFull()
        } else if remainingPoints > 0 {
            calculatedTotalPointsRemainingPoints(remainingPoints)
        } else if remainingPoints < 0 {
            calculatedTotalPointsError("Toplam Puan 15 olmalı!")
        }
    }
    
    func configureSpaceship() {
        //let spaceship = Spaceship(name: name, capacity: capacity, durability: durability, speed: speed)
        // TODO: - 
    }
    
    func checkSlidersEnable() -> Bool {
        return remainingPoints != 0
    }
    
    func reset() {
        capacity = 0
        durability = 0
        speed = 0
        totalPoints = 15
        remainingPoints = 15
    }
}

// MARK: - Validation

extension LandingViewModel {
    func validateConfiguration() -> Bool {
        if capacity <= 0 || speed <= 0 || durability <= 0 {
            return false
        }
        return true
    }
}
