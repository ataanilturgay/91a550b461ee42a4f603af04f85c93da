//
//  ApiClient.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

typealias GetStationsCompletion = (Result<[Station], ApiError>) -> Void

protocol API {
    
    func getStations(request: GetStationsRequest, onComplete: @escaping GetStationsCompletion)
}

struct APIClient: API {
    
    let network: Network
    
    func getStations(request: GetStationsRequest, onComplete: @escaping GetStationsCompletion) {
        network.request(apiRequest: request) { (result: Result<[Station], ApiError>) in
            onComplete(result)
        }
    }
}
