//
//  BaseHeader.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

typealias HTTPHeader = BaseHTTPHeader

enum BaseHTTPHeader: String, HeaderProtocol {

    case authorization = "Authorization"
    case accept = "Accept"

    func value() -> String {

        switch self {
        case .authorization:
            return "" // Header gerekli olsaydı token için bu alan doldurulabilirdi.
        case .accept:
            return ""
        }
    }

    static func header(for headerFields: [BaseHTTPHeader]) -> [String: String] {
        var headers = [String: String]()
        for headerField in headerFields {
            headers[headerField.rawValue] = headerField.value()
        }
        return headers
    }

    static func authorizedHeaders() -> [BaseHTTPHeader] {
        return [.authorization, .accept]
    }
    
    static func unauthorizedHeaders() -> [BaseHTTPHeader] {
        return [.accept]
    }
}

extension Array where Element == BaseHTTPHeader {
    
    func dictionary() -> [String: String] {
        return BaseHTTPHeader.header(for: self)
    }
}
