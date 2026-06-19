//
//  PNTimeCalculator.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.05.2022.
//

import Foundation

/// Type for calculating the time of a push notification occurrence.
protocol PNTimeCalculator {

    /// Calculate the time of a push notification occurrence.
    /// - Parameters:
    ///  - forDate: source date and time for calculation.
    /// - Returns:
    ///  - time of the push notification occurrence.
    func calculate(forDate date: Date) -> DateComponents
}
