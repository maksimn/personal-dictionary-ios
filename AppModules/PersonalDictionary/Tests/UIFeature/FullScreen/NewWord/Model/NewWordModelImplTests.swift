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

    func test_saveSourceLang_callsStorageAPI() throws {
        // Arrange
        var callsNumber = 0
        let langRepositoryMock = LangRepositoryMock()
        let model = NewWordModelImpl(
            langRepository: langRepositoryMock,
            newWordStream: NewWordStreamMock(),
            logger: LoggerMock()
        )

        langRepositoryMock.setSourceLangMock = { _ in callsNumber += 1 }

        // Act
        model.save(sourceLang: lang)

        // Assert
        XCTAssertEqual(callsNumber, 1)
    }

    func test_saveTargetLang_callsStorageAPI() throws {
        // Arrange
        var callsNumber = 0
        let langRepositoryMock = LangRepositoryMock()
        let model = NewWordModelImpl(
            langRepository: langRepositoryMock,
            newWordStream: NewWordStreamMock(),
            logger: LoggerMock()
        )
        langRepositoryMock.setTargetLangMock = { _ in callsNumber += 1 }

        // Act
        model.save(targetLang: lang)

        // Assert
        XCTAssertEqual(callsNumber, 1)
    }

    func test_sendNewWord_callsModelStream() throws {
        // Arrange
        var callsNumber = 0
        let newWordStreamMock = NewWordStreamMock()
        let model = NewWordModelImpl(
            langRepository: LangRepositoryMock(),
            newWordStream: newWordStreamMock,
            logger: LoggerMock()
        )

        newWordStreamMock.methodMock = { _ in callsNumber += 1 }

        // Act
        model.sendNewWord(Word(text: "a", sourceLang: lang, targetLang: lang))

        // Assert
        XCTAssertEqual(callsNumber, 1)
    }
}
