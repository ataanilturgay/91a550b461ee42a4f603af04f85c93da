//
//  GetStationsRequest.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

final class GetStationsRequest: BaseRequest {
    
    init() {}
    
    var body = [String : Any]()
    
    typealias Response = [Station]
        
    var method = RequestHTTPMethod.GET
    var path: String {
        return "e7211664-cbb6-4357-9c9d-f12bf8bab2e2"
    }
    var parameters = [String: String]()
}
