//
//  NetworkLayer.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

import Foundation

typealias RequestCompletion<T> = (Result<T, ApiError>) -> Void

protocol Network {
    
    func request<T: Decodable>(apiRequest: BaseRequest, onComplete: @escaping RequestCompletion<T>)
}

final class NetworkLayer: Network {
    
    func request<T>(apiRequest: BaseRequest, onComplete: @escaping RequestCompletion<T>) where T : Decodable {
        guard let url = URL(string: Constants.Network.baseUrl) else {
            let error = ApiError.badURL
            onComplete(.failure(error))
            return
        }
            
        let requestUrl = apiRequest.request(with: url)
        
        URLSession.shared.dataTask(with: requestUrl) { data, response, error in
            guard let data = data else {
                onComplete(.failure(.unknown))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                onComplete(.success(decoded))
            } catch {
                onComplete(.failure(ApiError.parsing(.none)))
            }
        }.resume()
    }
    
    public init() {}
}
