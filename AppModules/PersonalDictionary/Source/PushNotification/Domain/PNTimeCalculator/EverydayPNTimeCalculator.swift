//
//  EverydayPNTimeCalculator.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.05.2022.
//

import Foundation

/// Реализация типа для вычисления времени возникновения ежедневного пуш-уведомления.
final class EverydayPNTimeCalculator: PNTimeCalculator {

    private let hours: Int
    private let minutes: Int
    private let calendar: Calendar

    /// Инициализатор.
    /// - Parameters:
    ///  - hours: час для показа уведомления.
    ///  - minutes: минута для показа уведомления.
    ///  - calendar: системный календарь.
    init(hours: Int, minutes: Int, calendar: Calendar) {
        self.hours = hours
        self.minutes = minutes
        self.calendar = calendar
    }

    /// Вычислить время возникновения пуш-уведомления.
    /// - Parameters:
    ///  - forDate: исходная дата и время для отсчёта.
    /// - Returns:
    ///  - время возникновения пуш-уведомления.
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
