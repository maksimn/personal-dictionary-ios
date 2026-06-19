//
//  EverydayPNTimeCalculator.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.05.2022.
//

import Foundation

/// Implementation of the type for calculating the time of a daily push notification occurrence.
final class EverydayPNTimeCalculator: PNTimeCalculator {

    private let hours: Int
    private let minutes: Int
    private let calendar: Calendar

    /// Initializer.
    /// - Parameters:
    ///  - hours: hour for showing the notification.
    ///  - minutes: minute for showing the notification.
    ///  - calendar: system calendar.
    init(hours: Int, minutes: Int, calendar: Calendar) {
        self.hours = hours
        self.minutes = minutes
        self.calendar = calendar
    }

    /// Calculate the time of a push notification occurrence.
    /// - Parameters:
    ///  - forDate: source date and time for calculation.
    /// - Returns:
    ///  - time of the push notification occurrence.
    func calculate(forDate date: Date) -> DateComponents {
        let inputComponents = calendar.dateComponents(
            Set([.year, .month, .day, .hour, .minute, .second]),
            from: date
        )
        guard let inputHour = inputComponents.hour,
              let inputMinute = inputComponents.minute,
              let inputDay = inputComponents.day else { return DateComponents() }

        return DateComponents(
            year: inputComponents.year,
            month: inputComponents.month,
            day: inputHour <= hours && inputMinute <= minutes ? inputDay : inputDay + 1,
            hour: hours,
            minute: minutes,
            second: inputComponents.second
        )
    }
}
