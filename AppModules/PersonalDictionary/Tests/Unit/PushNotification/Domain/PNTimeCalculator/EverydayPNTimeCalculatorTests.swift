//
//  EverydayPNTimeCalculatorTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 14.05.2022.
//

import XCTest
@testable import PersonalDictionary

final class EverydayPNTimeCalculatorTests: XCTestCase {

    let calendar = Calendar(identifier: .gregorian)

    func test_calculate_currentTimeBeforeSpecifiedNotificationTime() throws {
        // Arrange:
        let components = DateComponents(year: 2022, month: 6, day: 15, hour: 18, minute: 15, second: 0)
        let current = calendar.date(from: components)!

        let pnTimeCalculator = EverydayPNTimeCalculator(hours: 19, minutes: 30, calendar: calendar)

        // Act:
        let dateComponents = pnTimeCalculator.calculate(forDate: current)

        // Assert:
        XCTAssertEqual(dateComponents, DateComponents(year: 2022, month: 6, day: 15, hour: 19, minute: 30, second: 0))
    }

    func test_calculate_currentTimeAfterSpecifiedNotificationTime() throws {
        // Arrange:
        let components = DateComponents(year: 2022, month: 6, day: 15, hour: 20, minute: 45, second: 0)
        let current = calendar.date(from: components)!

        let pnTimeCalculator = EverydayPNTimeCalculator(hours: 19, minutes: 30, calendar: calendar)

        // Act:
        let dateComponents = pnTimeCalculator.calculate(forDate: current)

        // Assert:
        XCTAssertEqual(dateComponents, DateComponents(year: 2022, month: 6, day: 16, hour: 19, minute: 30, second: 0))
    }
}
