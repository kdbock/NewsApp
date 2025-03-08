//
//  BrandColors.swift
//  NewsApp
//
//  A simple struct holding your brand color constants.
//  Make sure this file is in the "NewsApp" target membership.
//

import UIKit

struct BrandColors {
    static let gold = UIColor(hex: "#d2982a") ?? .systemYellow
    static let darkGray = UIColor(hex: "#2d2c31") ?? .darkGray
}

// Optionally, include this hex-color initializer if needed:
extension UIColor {
    convenience init?(hex: String) {
        var trimmed = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if trimmed.hasPrefix("#") {
            trimmed.remove(at: trimmed.startIndex)
        }
        guard trimmed.count == 6 || trimmed.count == 8 else { return nil }

        var rgbValue: UInt64 = 0
        Scanner(string: trimmed).scanHexInt64(&rgbValue)

        if trimmed.count == 6 {
            let r = (rgbValue & 0xFF0000) >> 16
            let g = (rgbValue & 0x00FF00) >> 8
            let b = rgbValue & 0x0000FF
            self.init(red: CGFloat(r) / 255.0,
                      green: CGFloat(g) / 255.0,
                      blue: CGFloat(b) / 255.0,
                      alpha: 1.0)
        } else {
            let a = (rgbValue & 0xFF000000) >> 24
            let r = (rgbValue & 0x00FF0000) >> 16
            let g = (rgbValue & 0x0000FF00) >> 8
            let b = rgbValue & 0x000000FF
            self.init(red: CGFloat(r) / 255.0,
                      green: CGFloat(g) / 255.0,
                      blue: CGFloat(b) / 255.0,
                      alpha: CGFloat(a) / 255.0)
        }
    }
}
