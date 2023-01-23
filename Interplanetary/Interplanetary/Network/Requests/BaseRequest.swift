//
//  BaseRequest.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

import Foundation

typealias BaseResponse = Decodable

enum RequestHTTPMethod: String {
    
    case GET, POST
}

protocol Request: AnyObject {
    
    func request(with baseURL: URL) -> URLRequest
}

protocol BaseRequest: Request {
    
    var method: RequestHTTPMethod { get }
    var path: String { get }
    var parameters: [String: String] { get }
    var body: [String: Any] { get }
}

extension BaseRequest {
    
    func request(with baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path),
                                             resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }

        if parameters.count > 0 {
            components.queryItems = parameters.map {
                URLQueryItem(name: String($0), value: String($1))
            }
        }

        guard let url = components.url else {
            fatalError("Could not get url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        print("\n- - - - - - - - - - - - - -\n")
        print("request: \(request)")
        print("request method: \(String(describing: request.httpMethod))")
        
        if request.httpMethod == "POST" {
            if let requestBody = try? JSONSerialization.data(withJSONObject: body) {
                request.httpBody = requestBody
                
                print("request body: \(String(describing: requestBody.prettyPrintedJSONString))")
            }
        }
        request.allHTTPHeaderFields = BaseHTTPHeader.authorizedHeaders().dictionary()
        return request
    }
}
