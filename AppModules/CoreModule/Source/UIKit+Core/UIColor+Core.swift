//
//  UIColor+Core.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 30.03.2022.
//

import UIKit

public extension UIColor {

    /// Creates a color object that generates its color data dynamically using the specified colors.
    /// For early SDKs creates light color.
    /// - Parameters:
    ///   - light: The color for light mode.
    ///   - dark: The color for dark mode.
    convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13.0, tvOS 13.0, *) {
            self.init { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                }
                return light
            }
        } else {
            self.init(cgColor: light.cgColor)
        }
    }
}
