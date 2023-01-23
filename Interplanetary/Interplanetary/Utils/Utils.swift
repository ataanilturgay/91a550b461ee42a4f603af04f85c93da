//
//  Utils.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

import Foundation

struct Utils {
    
    static func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }

    static func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
}
