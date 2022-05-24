//
//  EverydayPNTimeCalculator.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.05.2022.
//

import Foundation

/// Реализация типа для вычисления времени возникновения ежедневного пуш-уведомления.
final class EverydayPNTimeCalculator: PNTimeCalculator {

    private let hh: Int
    private let mm: Int
    private let calendar: Calendar

    /// Инициализатор.
    /// - Parameters:
    ///  - hh: час для показа уведомления.
    ///  - mm: минута для показа уведомления.
    ///  - calendar: системный календарь.
    init(hh: Int, mm: Int, calendar: Calendar) {
        self.hh = hh
        self.mm = mm
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
            day: inputHour <= hh && inputMinute <= mm ? inputDay : inputDay + 1,
            hour: hh,
            minute: mm,
            second: inputComponents.second
        )
    }
}
