//
//  PNTimeCalculator.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.05.2022.
//

/// Тип для вычисления времени возникновения пуш-уведомления.
protocol PNTimeCalculator {

    /// Вычислить время возникновения пуш-уведомления.
    /// - Parameters:
    ///  - forDate: исходная дата и время для отсчёта.
    /// - Returns:
    ///  - время возникновения пуш-уведомления.
    func calculate(forDate date: Date) -> DateComponents
}
