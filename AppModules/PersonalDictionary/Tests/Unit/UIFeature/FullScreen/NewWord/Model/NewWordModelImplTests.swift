//
//  NewWordModelImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 02.03.2023.
//

import XCTest
@testable import PersonalDictionary

final class NewWordModelImplTests: XCTestCase {

    var model: NewWordModelImpl!

    // MARK: - Mocks

    var langRepositoryMock: LangRepositoryMock!
    var newWordSenderMock: NewWordSenderMock!

    // MARK: - Test data set

    let lang = Lang.defaultValueFUT
    let otherLang = Lang(id: .init(raw: 2), nameKey: .init(raw: "Bb"), shortNameKey: .init(raw: "b"))
    lazy var initialLangPickerState = LangPickerState(lang: lang, langType: .source, isHidden: true)
    lazy var initialState = NewWordState(
        text: "", sourceLang: lang, targetLang: lang, langPickerState: initialLangPickerState
    )

    func arrange() {
        langRepositoryMock = LangRepositoryMock()
        newWordSenderMock = NewWordSenderMock()
        model = NewWordModelImpl(
            langRepository: langRepositoryMock,
            newWordSender: newWordSenderMock,
            logger: LoggerMock()
        )
    }

    // MARK: - Unit tests

    func test_selectLangEffect_sourceLangSelection_newSourceLangDidSet() throws {
        // Arrange
        arrange()

        let langPickerState = LangPickerState(lang: otherLang, langType: .source, isHidden: true)

        // Act
        let state = model.selectLangEffect(langPickerState, state: initialState)

        // Assert
        XCTAssertEqual(
            state,
            NewWordState(
                text: initialState.text,
                sourceLang: otherLang,
                targetLang: lang,
                langPickerState: langPickerState
            )
        )
    }

    func test_selectLangEffect_sourceLangSelection_updatesSourceLangStorage() throws {
        // Arrange
        var storageUpdateCount = 0
        let langPickerState = LangPickerState(lang: otherLang, langType: .source, isHidden: true)

        arrange()
        langRepositoryMock.setSourceLangMock = { _ in storageUpdateCount += 1 }

        // Act
        _ = model.selectLangEffect(langPickerState, state: initialState)

        // Assert
        XCTAssertEqual(storageUpdateCount, 1)
    }

    func test_selectLangEffect_targetLangSelection_newTargetLangDidSet() throws {
        // Arrange
        arrange()

        let langPickerState = LangPickerState(lang: otherLang, langType: .target, isHidden: true)

        // Act
        let state = model.selectLangEffect(langPickerState, state: initialState)

        // Assert
        XCTAssertEqual(
            state,
            NewWordState(
                text: initialState.text,
                sourceLang: lang,
                targetLang: otherLang,
                langPickerState: langPickerState
            )
        )
    }

    func test_selectLangEffect_targetLangSelection_updatesTargetLangStorage() throws {
        // Arrange
        var storageUpdateCount = 0
        let langPickerState = LangPickerState(lang: otherLang, langType: .target, isHidden: true)

        arrange()
        langRepositoryMock.setTargetLangMock = { _ in storageUpdateCount += 1 }

        // Act
        _ = model.selectLangEffect(langPickerState, state: initialState)

        // Assert
        XCTAssertEqual(storageUpdateCount, 1)
    }

    func test_presentLangPicker_toSelectSourceLang() throws {
        arrange()

        // Act
        let state = model.presentLangPicker(langType: .source, state: initialState)

        // Assert
        XCTAssertEqual(
            state,
            NewWordState(
                text: initialState.text,
                sourceLang: initialState.sourceLang,
                targetLang: initialState.targetLang,
                langPickerState: LangPickerState(
                    lang: initialState.sourceLang,
                    langType: .source,
                    isHidden: false
                )
            )
        )
    }

    func test_presentLangPicker_toSelectTargetLang() throws {
        arrange()

        // Act
        let state = model.presentLangPicker(langType: .target, state: initialState)

        // Assert
        XCTAssertEqual(
            state,
            NewWordState(
                text: initialState.text,
                sourceLang: initialState.sourceLang,
                targetLang: initialState.targetLang,
                langPickerState: LangPickerState(
                    lang: initialState.targetLang,
                    langType: .target,
                    isHidden: false
                )
            )
        )
    }

    func test_sendNewWord_callsModelStream() throws {
        // Arrange
        var notificationCount = 0
        let state = NewWordState(text: "a", sourceLang: lang, targetLang: lang, langPickerState: initialLangPickerState)

        arrange()
        newWordSenderMock.methodMock = { _ in notificationCount += 1 }

        // Act
        model.sendNewWord(state)

        // Assert
        XCTAssertEqual(notificationCount, 1)
    }

    func test_sendNewWord_notSendingIfWordTextIsEmpty() throws {
        // Arrange
        var notificationCount = 0

        arrange()
        newWordSenderMock.methodMock = { _ in notificationCount += 1 }

        // Act
        model.sendNewWord(initialState)

        // Assert
        XCTAssertEqual(notificationCount, 0)
    }
}
