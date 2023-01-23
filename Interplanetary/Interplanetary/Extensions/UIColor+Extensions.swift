//
//  UIColor+Extensions.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 19.01.2023.
//

import UIKit

extension UIColor {
    
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return light }
        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }
}

public extension UIColor {

    /// Return color from hex code
    ///
    /// - Parameters:
    ///   - string: Hex code string
    ///   - alpha: Alpha value as `CGFloat`
    /// - Returns: Color as `UIColor`
    static func from(hex string: String, alpha: CGFloat = 1.0) -> UIColor {

        var hexString = string
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        return hexString.count == 6 ? hextToRgb(hex: hexString, alpha: alpha) : hextToRgba(hex: hexString)
    }

    /// Return rgb color from hex code
    ///
    /// - Parameters:
    ///   - string: Hex code string
    ///   - alpha: Alpha value as `CGFloat`
    /// - Returns: Color as `UIColor`
    static func hextToRgb(hex string: String, alpha: CGFloat = 1.0) -> UIColor {

        var hexString = string
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        let scanner = Scanner(string: hexString)
        scanner.scanLocation = 0
        var colorValue: UInt32 = 0
        scanner.scanHexInt32(&colorValue)

        let r = (colorValue & 0xFF0000) >> 16
        let g = (colorValue & 0x00FF00) >> 8
        let b = (colorValue & 0x0000FF)

        return UIColor(red: CGFloat(r)/0xFF, green: CGFloat(g)/0xFF, blue: CGFloat(b)/0xFF, alpha: alpha)
    }

    /// Return rgba color from hex code
    ///
    /// - Parameter string: Hex code string
    /// - Returns: Color as `UIColor`
    static func hextToRgba(hex string: String) -> UIColor {

        var hexString = string
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        let scanner = Scanner(string: hexString)
        scanner.scanLocation = 0
        var colorValue: UInt64 = 0
        scanner.scanHexInt64(&colorValue)

        let r = (colorValue & 0xFF000000) >> 24
        let g = (colorValue & 0x00FF0000) >> 16
        let b = (colorValue & 0x0000FF00) >> 8
        let a = (colorValue & 0x000000FF)

        return UIColor(red: CGFloat(r)/0xFF, green: CGFloat(g)/0xFF, blue: CGFloat(b)/0xFF, alpha: CGFloat(a)/0xFF)
    }
}

extension UIColor {
    
    class var textColor: UIColor {
        return .dynamicColor(light: .from(hex: "1a390a"), dark: .from(hex: "#ffffff"))
    }
    
    class var backgroundColor: UIColor {
        return .dynamicColor(light: .from(hex: "#000000"), dark: .from(hex: "#ffffff"))
    }
    
    class var appBackgroundColor: UIColor {
        return .dynamicColor(light: .from(hex: "#FAF0E6"), dark: .from(hex: "#507963"))
    }
}
