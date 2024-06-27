//
//  NewWordUDFTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 23.06.2024.
//

import XCTest
@testable import PersonalDictionary

class NewWordTests: XCTestCase {

    var newWord: NewWord!

    let lang = Lang(id: .init(raw: 3), nameKey: .init(raw: "Aa"), shortNameKey: .init(raw: "A"))
    let otherLang = Lang(id: .init(raw: 2), nameKey: .init(raw: "Bb"), shortNameKey: .init(raw: "b"))

    var langRepositoryMock: LangRepositoryMock!
    var newWordSenderMock: NewWordSenderMock!

    func arrange() {
        newWordSenderMock = NewWordSenderMock()
        langRepositoryMock = LangRepositoryMock()
        langRepositoryMock.getSourceLangMock = { Lang.defaultValueFUT }
        langRepositoryMock.getTargetLangMock = { Lang.defaultValueFUT }
        newWord = NewWord(
            langRepository: langRepositoryMock,
            newWordSender: newWordSenderMock,
            logger: LoggerMock()
        )
    }

    func test_reducer_loadAction_loadsSourceLang() throws {
        // Arrange
        arrange()
        langRepositoryMock.getSourceLangMock = { self.lang }

        var state = NewWordState()

        // Act
        newWord.reducer(state: &state, action: NewWordAction.load)

        // Assert
        XCTAssertEqual(state.sourceLang, lang)
    }

    func test_reducer_loadAction_loadsTargetLang() throws {
        // Arrange
        arrange()
        langRepositoryMock.getTargetLangMock = { self.lang }

        var state = NewWordState()

        // Act
        newWord.reducer(state: &state, action: NewWordAction.load)

        // Assert
        XCTAssertEqual(state.targetLang, lang)
    }

    func test_reducer_langSelectedAction_newSourceLangDidSet() throws {
        // Arrange
        arrange()

        var state = NewWordState(langPicker: LangPickerState(value: .init()))

        // Act
        newWord.reducer(state: &state, action: LangPickerAction.langSelected(otherLang))

        // Assert
        XCTAssertEqual(state.sourceLang, otherLang)
    }

    func test_reducer_langSelectedAction_updatesSourceLangStorage() throws {
        // Arrange
        var storageUpdateCount = 0
        var state = NewWordState(langPicker: LangPickerState(value: .init()))

        arrange()
        langRepositoryMock.setSourceLangMock = { _ in storageUpdateCount += 1 }

        // Act
        newWord.reducer(state: &state, action: LangPickerAction.langSelected(otherLang))

        // Assert
        XCTAssertEqual(storageUpdateCount, 1)
    }

    func test_reducer_langSelectedAction_newTargetLangDidSet() throws {
        // Arrange
        arrange()

        var state = NewWordState()
        let langPickerState = LangPickerState(value: .init(lang: otherLang, langType: .target))

        state.langPicker = langPickerState

        // Act
        newWord.reducer(state: &state, action: LangPickerAction.langSelected(otherLang))

        // Assert
        XCTAssertEqual(state.targetLang, otherLang)
    }

    func test_reducer_langSelectedAction_updatesTargetLangStorage() throws {
        // Arrange
        var storageUpdateCount = 0
        var state = NewWordState()

        arrange()
        langRepositoryMock.setTargetLangMock = { _ in storageUpdateCount += 1 }
        state.langPicker = LangPickerState(value: .init(lang: otherLang, langType: .target))

        // Act
        newWord.reducer(state: &state, action: LangPickerAction.langSelected(otherLang))

        // Assert
        XCTAssertEqual(storageUpdateCount, 1)
    }

    func test_reducer_langPickerShowAction_toSelectSourceLang() throws {
        // Arrange
        arrange()

        var state = NewWordState()

        // Act
        newWord.reducer(state: &state, action: LangPickerAction.show(.source))

        // Assert
        XCTAssertEqual(
            state.langPicker,
            LangPickerState(
                value: .init(
                    lang: Lang.empty,
                    langType: .source
                )
            )
        )
    }

    func test_reducer_langPickerShowAction_toSelectTargetLang() throws {
        // Arrange
        arrange()

        var state = NewWordState()

        // Act
        newWord.reducer(state: &state, action: LangPickerAction.show(.target))

        // Assert
        XCTAssertEqual(
            state.langPicker,
            LangPickerState(
                value: .init(
                    lang: Lang.empty,
                    langType: .target
                )
            )
        )
    }

    func test_reducer_sendNewWordAction_callsModelStream() throws {
        // Arrange
        var notificationCount = 0
        var state = NewWordState(text: "a")

        arrange()
        newWordSenderMock.methodMock = { _ in notificationCount += 1 }

        // Act
        newWord.reducer(state: &state, action: NewWordAction.sendNewWord)

        // Assert
        XCTAssertEqual(notificationCount, 1)
    }

    func test_reducer_sendNewWordAction_doesNotSendIfWordTextIsEmpty() throws {
        // Arrange
        var notificationCount = 0
        var state = NewWordState()

        arrange()
        newWordSenderMock.methodMock = { _ in notificationCount += 1 }

        // Act
        newWord.reducer(state: &state, action: NewWordAction.sendNewWord)

        // Assert
        XCTAssertEqual(notificationCount, 0)
    }

    func test_reducer_textChangedAction_textIsEmpty() throws {
        // Arrange
        arrange()

        var state = NewWordState()

        // Act
        newWord.reducer(state: &state, action: NewWordAction.textChanged(""))

        // Assert
        XCTAssertEqual(state, NewWordState())
    }

    func test_reducer_textChangedAction_textIsSomeString() throws {
        // Arrange
        arrange()

        var state = NewWordState()

        // Act
        newWord.reducer(state: &state, action: NewWordAction.textChanged("Abc"))

        // Assert
        XCTAssertEqual(state, NewWordState(text: "Abc"))
    }

    func test_reducer_langPickerHideAction_setsStateValueToNil() throws {
        // Arrange
        arrange()

        var state = NewWordState(langPicker: LangPickerState(value: .init()))

        // Act
        newWord.reducer(state: &state, action: LangPickerAction.hide)

        // Assert
        XCTAssertEqual(state, NewWordState(langPicker: LangPickerState(value: nil)))
    }
}
