//
//  ApiError.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

import Foundation

public enum ApiError: Error, CustomStringConvertible {
    
    case badURL
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .badURL, .parsing, .unknown:
            return "Sorry, something went wrong."
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong."
        }
    }
    
    public var description: String {
        switch self {
        case .unknown: return "unknown error"
        case .badURL: return "invalid URL"
        case .url(let error):
            return error?.localizedDescription ?? "url session error"
        case .parsing(let error):
            return "parsing error \(error?.localizedDescription ?? "")"
        }
    }
}
