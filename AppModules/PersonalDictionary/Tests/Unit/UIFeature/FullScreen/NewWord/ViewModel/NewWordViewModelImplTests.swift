//
//  NewWordViewModelImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 02.03.2023.
//

import XCTest
@testable import PersonalDictionary

final class NewWordViewModelImplTests: XCTestCase {

    var viewModel: NewWordViewModelImpl!
    var modelMock: NewWordModelMock!

    let lang = Lang.defaultValueFUT
    lazy var initialState = NewWordState(
        text: "",
        sourceLang: lang,
        targetLang: lang,
        langPickerState: LangPickerState(lang: lang, langType: .source, isHidden: true)
    )

    func arrange() {
        modelMock = NewWordModelMock()
        viewModel = NewWordViewModelImpl(model: modelMock, initState: initialState, logger: LoggerMock())
    }

    func test_updateText_textIsEmpty() throws {
        arrange()

        // Act
        viewModel.update(text: "")

        // Assert
        XCTAssertEqual(viewModel.state.value.text, "")
    }

    func test_updateText_textIsSomeString() throws {
        arrange()

        // Act
        viewModel.update(text: "Abc")

        // Assert
        XCTAssertEqual(viewModel.state.value.text, "Abc")
    }

    func test_onLangPickerStateChanged() throws {
        // Arrange
        arrange()

        let otherLang = Lang(id: .init(raw: 2), nameKey: .init(raw: "Bb"), shortNameKey: .init(raw: "b"))
        let newLangPickerState = LangPickerState(lang: otherLang, langType: .target, isHidden: true)
        let newState = NewWordState(
            text: initialState.text, sourceLang: lang, targetLang: otherLang, langPickerState: newLangPickerState
        )

        modelMock.selectLangEffectMock = { (_, _) in newState }

        // Act
        viewModel.onLangPickerStateChanged(newLangPickerState)

        // Assert
        XCTAssertEqual(viewModel.state.value, newState)
    }

    func test_presentLangPicker_toSelectSourceLang() throws {
        // Arrange
        arrange()
        modelMock.presentLangPickerMock = { (_, state) in
            var state = state

            state.langPickerState.isHidden = false
            state.langPickerState.langType = .source

            return state
        }

        // Act
        viewModel.presentLangPicker(langType: .source)

        // Assert
        XCTAssertEqual(
            viewModel.state.value.langPickerState,
            LangPickerState(lang: lang, langType: .source, isHidden: false)
        )
    }

    func test_presentLangPicker_toSelectTargetLang() throws {
        // Arrange
        arrange()
        modelMock.presentLangPickerMock = { (_, state) in
            var state = state

            state.langPickerState.isHidden = false
            state.langPickerState.langType = .target

            return state
        }

        // Act
        viewModel.presentLangPicker(langType: .target)

        // Assert
        XCTAssertEqual(
            viewModel.state.value.langPickerState,
            LangPickerState(lang: lang, langType: .target, isHidden: false)
        )
    }

    func test_sendNewWord_notifiesAboutNewWord() throws {
        // Arrange
        var notificationCount = 0

        arrange()
        modelMock.sendNewWordMock = { _ in notificationCount += 1 }

        // Act
        viewModel.sendNewWord()

        // Assert
        XCTAssertEqual(notificationCount, 1)
    }
}
