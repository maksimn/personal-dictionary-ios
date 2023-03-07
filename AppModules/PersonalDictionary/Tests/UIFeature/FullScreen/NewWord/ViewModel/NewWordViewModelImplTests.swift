//
//  NewWordViewModelImplTests.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 02.03.2023.
//

import XCTest
@testable import PersonalDictionary

final class NewWordViewModelImplTests: XCTestCase {

    let lang = Lang(id: .init(raw: 1), name: "", shortName: "")
    lazy var initState = NewWordState(
        text: "",
        sourceLang: lang,
        targetLang: lang,
        langPickerState: LangPickerState(lang: lang, langType: .source, isHidden: true)
    )

    func test_updateText_textIsEmpty() throws {
        // Arrange
        let mockModel = MockNewWordModel()
        let viewModel = NewWordViewModelImpl(model: mockModel, initState: initState)

        // Act
        viewModel.update(text: "")

        // Assert
        XCTAssertEqual(viewModel.state.value.text, "")
    }

    func test_updateText_textIsSomeString() throws {
        // Arrange
        let mockModel = MockNewWordModel()
        let viewModel = NewWordViewModelImpl(model: mockModel, initState: initState)

        // Act
        viewModel.update(text: "Abc")

        // Assert
        XCTAssertEqual(viewModel.state.value.text, "Abc")
    }

    func test_updateStateWithLangPickerState_newTargetLang() throws {
        // Arrange
        let mockModel = MockNewWordModel()
        let viewModel = NewWordViewModelImpl(model: mockModel, initState: initState)
        let newLangPickerState = LangPickerState(
            lang: Lang(id: .init(raw: 2), name: "Bb", shortName: "b"),
            langType: .target,
            isHidden: true
        )

        // Act
        viewModel.updateStateWith(langPickerState: newLangPickerState)

        // Assert
        let state = viewModel.state.value

        XCTAssertEqual(state.langPickerState, newLangPickerState)
        XCTAssertEqual(state.targetLang, newLangPickerState.lang)
    }

    func test_updateStateWithLangPickerState_newSourceLang() throws {
        // Arrange
        let mockModel = MockNewWordModel()
        let viewModel = NewWordViewModelImpl(model: mockModel, initState: initState)
        let newLangPickerState = LangPickerState(
            lang: Lang(id: .init(raw: 2), name: "Bb", shortName: "b"),
            langType: .source,
            isHidden: true
        )

        // Act
        viewModel.updateStateWith(langPickerState: newLangPickerState)

        // Assert
        let state = viewModel.state.value

        XCTAssertEqual(state.langPickerState, newLangPickerState)
        XCTAssertEqual(state.sourceLang, newLangPickerState.lang)
    }

    func test_presentLangPicker_toSelectSourceLang() throws {
        // Arrange
        let mockModel = MockNewWordModel()
        let viewModel = NewWordViewModelImpl(model: mockModel, initState: initState)

        // Act
        viewModel.presentLangPicker(langType: .source)

        // Assert
        let langPickerState = viewModel.state.value.langPickerState

        XCTAssertEqual(langPickerState, LangPickerState(lang: initState.sourceLang, langType: .source, isHidden: false))
    }

    func test_presentLangPicker_toSelectTargetLang() throws {
        // Arrange
        let mockModel = MockNewWordModel()
        let viewModel = NewWordViewModelImpl(model: mockModel, initState: initState)

        // Act
        viewModel.presentLangPicker(langType: .target)

        // Assert
        let langPickerState = viewModel.state.value.langPickerState

        XCTAssertEqual(langPickerState, LangPickerState(lang: initState.targetLang, langType: .target, isHidden: false))
    }

    func test_sendNewWord_notSendingIfWordIsEmpty() throws {
        // Arrange
        var callsCounter = 0
        let mockModel = MockNewWordModel()
        let viewModel = NewWordViewModelImpl(model: mockModel, initState: initState)

        mockModel.mockSendNewWord = { _ in callsCounter += 1 }

        // Act
        viewModel.sendNewWord()

        // Assert
        XCTAssertEqual(callsCounter, 0)
    }

    func test_sendNewWord_callsModelMethod() throws {
        // Arrange
        var callsCounter = 0
        var state = initState

        state.text = "Word"

        let mockModel = MockNewWordModel()
        let viewModel = NewWordViewModelImpl(model: mockModel, initState: state)

        mockModel.mockSendNewWord = { _ in callsCounter += 1 }

        // Act
        viewModel.sendNewWord()

        // Assert
        XCTAssertEqual(callsCounter, 1)
    }
}
