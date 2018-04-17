//
//  UIColor+Ex.swift
//  Lobster
//
//  Created by suguru-kishimoto on 2017/11/02.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import UIKit

extension String {
    var hexColor: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3:
            (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
        case 6:
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8:
            (r, g, b, a) = (int >> 24 & 0xFF, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIColor {
    typealias RGBA = (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)
    var rgba: RGBA {
        var rgba: RGBA = (0, 0, 0, 0)
        if getRed(&rgba.r, green: &rgba.g, blue: &rgba.b, alpha: &rgba.a) {
            return rgba
        }
        return (0.0, 0.0, 0.0, 0.0)
    }

    var hexString: String {
        return String(format: "#%02x%02x%02x%02x", Int(rgba.r * 255), Int(rgba.g * 255),Int(rgba.b * 255),Int(rgba.a * 255) )
    }
}
