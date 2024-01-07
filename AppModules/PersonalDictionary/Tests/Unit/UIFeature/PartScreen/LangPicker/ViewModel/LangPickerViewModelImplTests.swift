//
//  LangPickerViewModelImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 27.02.2023.
//

import XCTest
@testable import PersonalDictionary

final class LangPickerViewModelImplTests: XCTestCase {

    private var viewModel: LangPickerViewModelImpl!

    private var langPickerListenerMock: LangPickerListenerMock!

    private let lang = Lang.defaultValueFUT

    private var listenerCallCount = 0

    func test_onSelect_callsListener() throws {
        // Arrange
        arrange()
        viewModel.state.accept(LangPickerState(lang: lang, langType: .source, isHidden: false))

        // Act
        viewModel.onSelect(lang)

        // Assert
        XCTAssertEqual(listenerCallCount, 1)
    }

    func test_onSelect_doesNotCallListenerIfStateIsNil() throws {
        arrange()

        // Act
        viewModel.onSelect(lang)

        // Assert
        XCTAssertEqual(listenerCallCount, 0)
    }

    private func arrange() {
        viewModel = .init()
        langPickerListenerMock = .init()
        viewModel.listener = langPickerListenerMock
        langPickerListenerMock.methodMock = { _ in self.listenerCallCount += 1 }
        listenerCallCount = 0
    }
}
