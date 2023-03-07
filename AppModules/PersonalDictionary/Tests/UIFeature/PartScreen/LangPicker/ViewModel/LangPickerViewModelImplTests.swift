//
//  FavoriteWordListViewModelImplTests.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 27.02.2023.
//

import RxSwift
import XCTest
@testable import PersonalDictionary

final class LangPickerViewModelImplTests: XCTestCase {

    func test_onSelect_callsListener() throws {
        // Arrange
        var callsNumber = 0
        let langPickerListenerMock = LangPickerListenerMock()
        let viewModel = LangPickerViewModelImpl()
        let lang = Lang(id: .init(raw: 0), name: "", shortName: "")
        let state = LangPickerState(
            lang: lang,
            langType: .source,
            isHidden: false
        )

        langPickerListenerMock.methodMock = { _ in callsNumber += 1 }
        viewModel.state.accept(state)
        viewModel.listener = langPickerListenerMock

        // Act
        viewModel.onSelect(lang)

        // Assert
        XCTAssertEqual(callsNumber, 1)
    }

    func test_onSelect_doesNotCallListenerIfStateIsNil() throws {
        // Arrange
        var callsNumber = 0
        let langPickerListenerMock = LangPickerListenerMock()
        let viewModel = LangPickerViewModelImpl()
        let lang = Lang(id: .init(raw: 0), name: "", shortName: "")

        langPickerListenerMock.methodMock = { _ in callsNumber += 1 }
        viewModel.listener = langPickerListenerMock

        // Act
        viewModel.onSelect(lang)

        // Assert
        XCTAssertEqual(callsNumber, 0)
    }
}
