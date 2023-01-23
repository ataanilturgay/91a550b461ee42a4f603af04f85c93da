//
//  LandingViewModel.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 18.01.2023.
//

protocol LandingViewModelProtocol: AnyObject {
    
    var spaceshipName: String? { get set }
    var capacity: Int { get set }
    var durability: Int { get set }
    var speed: Int { get set }
    var totalPoints: Int { get set }
    var remainingPoints: Int { get set }

    func getRemainingPoints() -> Int
    func calculateTotalPoints()
    func setSpaceshipName(with value: String)
    
    func checkSlidersEnable() -> Bool
    
    func reset()
    
    func validateConfiguration() -> Bool
    func validate()
}

enum LandingErrorType {
    
    case totalPoint, sliderZero, spaceshipNameEmpty
    
    var errorMessage: String {
        switch self {
        case .totalPoint:
            return "Lütfen Dağıtılan Toplam Puan 15 Olacak Şekilde Ayarlarınızı Yapın"
        case .sliderZero:
            return "Lütfen 0'dan Farklı Değerler Girin"
        case .spaceshipNameEmpty:
            return "Lütfen Uzay Aracına Bir İsim Verin"
        }
    }
}

final class LandingViewModel: LandingViewModelProtocol {
    
    private enum Constants {
        
        enum Calculations {
            
            static let capacityMultiplier: Int = 10000
            static let speedMultiplier: Int = 20
            static let durabilityMultiplier: Int = 10000
        }
    }
    
    var spaceshipName: String?
    var capacity: Int = 0
    var durability: Int = 0
    var speed: Int = 0
    var totalPoints: Int = 15
    var remainingPoints: Int = 0
    var error: LandingErrorType = .spaceshipNameEmpty

    public var calculatedTotalPointsSuccess = { () -> Void in }
    public var calculatedTotalPointsRemainingPoints = { (remaining: Int) -> Void in }
    public var calculatedTotalPointsError = { () -> Void in }
    public var validationSuccess = { () -> Void in }
    public var validationError = { (error: LandingErrorType) -> Void in }
    
    func calculateTotalPoints() {
        let currentPoints = capacity + durability + speed
        remainingPoints = totalPoints - currentPoints
        
        if remainingPoints == 0 {
            calculatedTotalPointsSuccess()
        } else if remainingPoints > 0 {
            calculatedTotalPointsRemainingPoints(remainingPoints)
        } else if remainingPoints < 0 {
            calculatedTotalPointsError()
        }
    }
    
    func setSpaceshipName(with value: String) {
        MissionsManager.shared.setSpaceshipName(with: value)
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

// MARK: - Getters

extension LandingViewModel {
    
    func getRemainingPoints() -> Int {
        return remainingPoints
    }
}

// MARK: - Validation

extension LandingViewModel {
    
    func validateConfiguration() -> Bool {
        guard let name = spaceshipName, name.count > 0 else {
            error = .spaceshipNameEmpty
            return false
        }
        
        setSpaceshipName(with: name)
        
        if capacity <= 0 || speed <= 0 || durability <= 0 {
            error = .sliderZero
            return false
        }
        
        if remainingPoints != 0 {
            error = .totalPoint
            return false
        }
        return true
    }
    
    func validate() {
        if validateConfiguration() {
            MissionsManager.shared.setCurrentUGS(with: capacity * Constants.Calculations.capacityMultiplier)
            MissionsManager.shared.setCurrentEUS(with: speed * Constants.Calculations.speedMultiplier)
            MissionsManager.shared.setCurrentDS(with: durability * Constants.Calculations.durabilityMultiplier)
            validationSuccess()
        } else {
            validationError(error)
        }
    }
}
