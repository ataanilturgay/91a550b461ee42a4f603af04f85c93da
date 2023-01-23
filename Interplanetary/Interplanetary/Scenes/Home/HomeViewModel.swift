//
//  HomeViewModel.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

protocol HomeViewModelProtocol: AnyObject {
    
    func getSpaceshipName() -> String
    func getStations() -> [Station]
    func getStationsBySearch(with value: String)
    func updateStations()
    func checkDamage()
    func checkEUS()
    func checkUGS()
    
    func updateStation(with value: Station)
    func updateDamage(with value: Int)
    func updateEUS(with value: Int)
    func updateUGS(with value: Int)
    func reset()
}

final class HomeViewModel: BaseViewModel {
    
    var getStationsSuccess = { (stations: [Station]) -> Void in }
    var getStationsError = { () -> Void in }
    
    var getStationsBySearchCompleted = { (stations: [Station]) -> Void in }
    
    var updateStationsCompleted = { (stations: [Station]) -> Void in }
    
    var missionCompleted = { () -> Void in }

    private var stations = [Station]()
    private var searchedStations = [Station]()

    private var name: String
    init(provider: APIClient, name: String) {
        self.name = name
        super.init(provider: provider)
    }
}

// MARK: Api Calls

extension HomeViewModel {
    
    func fetchStations() {
        let request = GetStationsRequest()
        provider.getStations(request: request) { result in
            switch result {
            case .success(let response):
                if response.count > 0 {
                    self.stations = response
                    self.getStationsSuccess(self.getStations())
                }
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}

// MARK: - HomeViewModel Protocol

extension HomeViewModel: HomeViewModelProtocol {
    func getSpaceshipName() -> String {
        return name
    }
    
    func getStationsBySearch(with value: String) {
        searchedStations.removeAll()
        searchedStations = stations.filter { $0.name.contains(value.uppercased()) }
        getStationsBySearchCompleted(searchedStations)
    }
    
    func getStations() -> [Station] {
        return stations.filter { $0.name != MissionsManager.shared.getCurrentPlanetName() }
    }
    
    func updateStations() {
        updateStationsCompleted(getStations())
    }
    
    func checkEUS() {
        if MissionsManager.shared.getCurrentEUS() <= 0 {
            missionCompleted()
            reset()
        }
    }
    
    func checkUGS() {
        if MissionsManager.shared.getCurrentEUS() <= 0 {
            missionCompleted()
            reset()
        }
    }
    
    func checkDamage() {
        if MissionsManager.shared.getDamageCapacity() <= 0 {
            missionCompleted()
            reset()
        }
    }
    
    func updateStation(with value: Station) {
        MissionsManager.shared.setCurrentStation(with: value)
    }
    
    func updateEUS(with value: Int) {
        MissionsManager.shared.setCurrentEUS(with: MissionsManager.shared.getCurrentEUS() - value)
    }
    
    func updateUGS(with value: Int) {
        MissionsManager.shared.setCurrentUGS(with: MissionsManager.shared.getCurrentUGS() - value)
    }
    
    func updateDamage(with value: Int) {
        MissionsManager.shared.setCurrentDamageCapacity(with: value)
    }
    
    func reset() {
        MissionsManager.shared.reset()
    }
}

// MARK: - Calculations

extension HomeViewModel {
    
    func calculateUGS(currentValue: Int, value: Int) -> Int { // uzay giysi sayısı
        return currentValue - value
    }
    
    func calculateEUS(currentValue: Int, value: Int) -> Int { // uzay giysi sayısı
        return currentValue - value
    }
    
    func calculateDS(currentValue: Int, value: Int) -> Int { // uzay giysi sayısı
        return currentValue - value
    }
}

