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
        let mockLangPickerListener = MockLangPickerListener({ callsNumber += 1 })
        let viewModel = LangPickerViewModelImpl()
        let lang = Lang(id: .init(raw: 0), name: "", shortName: "")
        let state = LangPickerState(
            lang: lang,
            langType: .source,
            isHidden: false
        )

        viewModel.state.accept(state)
        viewModel.listener = mockLangPickerListener

        // Act
        viewModel.onSelect(lang)

        // Assert
        XCTAssertEqual(callsNumber, 1)
    }

    func test_onSelect_doesNotCallListenerIfStateIsNil() throws {
        // Arrange
        var callsNumber = 0
        let mockLangPickerListener = MockLangPickerListener({ callsNumber += 1 })
        let viewModel = LangPickerViewModelImpl()
        let lang = Lang(id: .init(raw: 0), name: "", shortName: "")

        viewModel.listener = mockLangPickerListener

        // Act
        viewModel.onSelect(lang)

        // Assert
        XCTAssertEqual(callsNumber, 0)
    }
}
