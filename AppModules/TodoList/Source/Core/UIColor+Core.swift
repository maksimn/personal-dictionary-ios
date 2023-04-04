//
//  UIColor+Core.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 23.01.2023.
//

import UIKit

extension UIColor {

    /// Creates a color object that generates its color data dynamically using the specified colors.
    /// - Parameters:
    ///   - light: The color for light mode.
    ///   - dark: The color for dark mode.
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
}
