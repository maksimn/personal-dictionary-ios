//
//  NewWordModelImplTests.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 02.03.2023.
//

import XCTest
@testable import PersonalDictionary

final class NewWordModelImplTests: XCTestCase {

    let lang = Lang(id: .init(raw: 1), name: "Aa", shortName: "a")
    let otherLang = Lang(id: .init(raw: 2), name: "Bb", shortName: "b")
    lazy var initLangPickerState = LangPickerState(lang: lang, langType: .source, isHidden: true)
    lazy var initState = NewWordState(text: "", sourceLang: lang, targetLang: lang,
                                      langPickerState: initLangPickerState)

    func test_selectLangEffect_sourceLangSelection_newSourceLangDidSet() throws {
        // Arrange
        var storageUpdateCount = 0
        let langRepositoryMock = LangRepositoryMock()
        let model = NewWordModelImpl(
            langRepository: langRepositoryMock,
            newWordStream: NewWordStreamMock(),
            logger: LoggerMock()
        )
        let langPickerState = LangPickerState(lang: otherLang, langType: .source, isHidden: true)

        langRepositoryMock.setSourceLangMock = { _ in storageUpdateCount += 1 }

        // Act
        let state = model.selectLangEffect(langPickerState, state: initState)

        // Assert
        XCTAssertEqual(storageUpdateCount, 1)
        XCTAssertEqual(
            state,
            NewWordState(
                text: initState.text,
                sourceLang: otherLang,
                targetLang: lang,
                langPickerState: langPickerState
            )
        )
    }

    func test_selectLangEffect_targetLangSelection_newTargetLangDidSet() throws {
        // Arrange
        var storageUpdateCount = 0
        let langRepositoryMock = LangRepositoryMock()
        let model = NewWordModelImpl(
            langRepository: langRepositoryMock,
            newWordStream: NewWordStreamMock(),
            logger: LoggerMock()
        )
        let langPickerState = LangPickerState(lang: otherLang, langType: .target, isHidden: true)

        langRepositoryMock.setTargetLangMock = { _ in storageUpdateCount += 1 }

        // Act
        let state = model.selectLangEffect(langPickerState, state: initState)

        // Assert
        XCTAssertEqual(storageUpdateCount, 1)
        XCTAssertEqual(
            state,
            NewWordState(
                text: initState.text,
                sourceLang: lang,
                targetLang: otherLang,
                langPickerState: langPickerState
            )
        )
    }

    func test_presentLangPicker_toSelectSourceLang() throws {
        // Arrange
        let model = NewWordModelImpl(
            langRepository: LangRepositoryMock(),
            newWordStream: NewWordStreamMock(),
            logger: LoggerMock()
        )

        // Act
        let state = model.presentLangPicker(langType: .source, state: initState)

        // Assert
        XCTAssertEqual(
            state,
            NewWordState(
                text: initState.text,
                sourceLang: initState.sourceLang,
                targetLang: initState.targetLang,
                langPickerState: LangPickerState(
                    lang: initState.sourceLang,
                    langType: .source,
                    isHidden: false
                )
            )
        )
    }

    func test_presentLangPicker_toSelectTargetLang() throws {
        // Arrange
        let model = NewWordModelImpl(
            langRepository: LangRepositoryMock(),
            newWordStream: NewWordStreamMock(),
            logger: LoggerMock()
        )

        // Act
        let state = model.presentLangPicker(langType: .target, state: initState)

        // Assert
        XCTAssertEqual(
            state,
            NewWordState(
                text: initState.text,
                sourceLang: initState.sourceLang,
                targetLang: initState.targetLang,
                langPickerState: LangPickerState(
                    lang: initState.targetLang,
                    langType: .target,
                    isHidden: false
                )
            )
        )
    }

    func test_sendNewWord_callsModelStream() throws {
        // Arrange
        var notificationCount = 0
        let newWordStreamMock = NewWordStreamMock()
        let model = NewWordModelImpl(
            langRepository: LangRepositoryMock(),
            newWordStream: newWordStreamMock,
            logger: LoggerMock()
        )
        let state = NewWordState(text: "a", sourceLang: lang, targetLang: lang, langPickerState: initLangPickerState)

        newWordStreamMock.methodMock = { _ in notificationCount += 1 }

        // Act
        model.sendNewWord(state)

        // Assert
        XCTAssertEqual(notificationCount, 1)
    }

    func test_sendNewWord_notSendingIfWordTextIsEmpty() throws {
        // Arrange
        var notificationCount = 0
        let newWordStreamMock = NewWordStreamMock()
        let model = NewWordModelImpl(
            langRepository: LangRepositoryMock(),
            newWordStream: newWordStreamMock,
            logger: LoggerMock()
        )

        newWordStreamMock.methodMock = { _ in notificationCount += 1 }

        // Act
        model.sendNewWord(initState)

        // Assert
        XCTAssertEqual(notificationCount, 0)
    }
}
