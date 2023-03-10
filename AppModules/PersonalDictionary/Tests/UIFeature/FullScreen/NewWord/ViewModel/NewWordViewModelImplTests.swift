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
        let modelMock = NewWordModelMock()
        let viewModel = NewWordViewModelImpl(model: modelMock, initState: initState)

        // Act
        viewModel.update(text: "")

        // Assert
        XCTAssertEqual(viewModel.state.value.text, "")
    }

    func test_updateText_textIsSomeString() throws {
        // Arrange
        let modelMock = NewWordModelMock()
        let viewModel = NewWordViewModelImpl(model: modelMock, initState: initState)

        // Act
        viewModel.update(text: "Abc")

        // Assert
        XCTAssertEqual(viewModel.state.value.text, "Abc")
    }

    func test_updateStateWithLangPickerState() throws {
        // Arrange
        let modelMock = NewWordModelMock()
        let viewModel = NewWordViewModelImpl(model: modelMock, initState: initState)
        let otherLang = Lang(id: .init(raw: 2), name: "Bb", shortName: "b")
        let newLangPickerState = LangPickerState(lang: otherLang, langType: .target, isHidden: true)
        let newState = NewWordState(
            text: initState.text, sourceLang: lang, targetLang: otherLang, langPickerState: newLangPickerState
        )

        modelMock.selectLangEffectMock = { (_, _) in newState }

        // Act
        viewModel.updateStateWith(langPickerState: newLangPickerState)

        // Assert
        XCTAssertEqual(viewModel.state.value, newState)
    }

    func test_presentLangPicker_toSelectSourceLang() throws {
        // Arrange
        var modelCallCount = 0
        let modelMock = NewWordModelMock()
        let viewModel = NewWordViewModelImpl(model: modelMock, initState: initState)

        modelMock.presentLangPickerMock = { (_, state) in
            modelCallCount += 1
            return state
        }

        // Act
        viewModel.presentLangPicker(langType: .source)

        // Assert
        XCTAssertEqual(modelCallCount, 1)
    }

    func test_presentLangPicker_toSelectTargetLang() throws {
        // Arrange
        var modelCallCount = 0
        let modelMock = NewWordModelMock()
        let viewModel = NewWordViewModelImpl(model: modelMock, initState: initState)

        modelMock.presentLangPickerMock = { (_, state) in
            modelCallCount += 1
            return state
        }

        // Act
        viewModel.presentLangPicker(langType: .target)

        // Assert
        XCTAssertEqual(modelCallCount, 1)
    }

    func test_sendNewWord_callsModelMethod() throws {
        // Arrange
        var callsCounter = 0
        let modelMock = NewWordModelMock()
        let viewModel = NewWordViewModelImpl(model: modelMock, initState: initState)

        modelMock.sendNewWordMock = { _ in callsCounter += 1 }

        // Act
        viewModel.sendNewWord()

        // Assert
        XCTAssertEqual(callsCounter, 1)
    }
}
