//
//  Station.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

import Foundation

struct Station: Decodable {
    
    let name: String
    let coordinateX: Int
    let coordinateY: Int
    let capacity: Int
    let stock: Int
    let need: Int
}

extension Station {
    
    var pointXY: CGPoint {
        return CGPoint(x: coordinateX, y: coordinateY)
    }
}

extension Station: Equatable {
    
    static func ==(lhs: Station, rhs: Station) -> Bool {
        return lhs.name == rhs.name
    }
}
