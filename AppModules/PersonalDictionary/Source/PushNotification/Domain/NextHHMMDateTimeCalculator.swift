//
//  NextHHMMDatetimeCalculator.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.05.2022.
//

final class NextHHMMDatetimeCalculator: DatetimeCalculator {

    func calculate() -> Date {
        Date(timeIntervalSinceNow: 25)
    }
}
