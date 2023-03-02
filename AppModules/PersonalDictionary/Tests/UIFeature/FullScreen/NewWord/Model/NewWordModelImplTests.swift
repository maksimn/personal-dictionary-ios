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
        let mockLangRepository = MockLangRepository(allLangsValue: [])
        let model = NewWordModelImpl(
            langRepository: mockLangRepository,
            newWordStream: MockNewWordStream(),
            logger: LoggerStub()
        )
        mockLangRepository.mockSetSourceLang = { callsNumber += 1 }

        // Act
        model.save(sourceLang: lang)

        // Assert
        XCTAssertEqual(callsNumber, 1)
    }

    func test_saveTargetLang_callsStorageAPI() throws {
        // Arrange
        var callsNumber = 0
        let mockLangRepository = MockLangRepository(allLangsValue: [])
        let model = NewWordModelImpl(
            langRepository: mockLangRepository,
            newWordStream: MockNewWordStream(),
            logger: LoggerStub()
        )
        mockLangRepository.mockSetTargetLang = { callsNumber += 1 }

        // Act
        model.save(targetLang: lang)

        // Assert
        XCTAssertEqual(callsNumber, 1)
    }

    func test_sendNewWord_callsModelStream() throws {
        // Arrange
        var callsNumber = 0
        let mockNewWordStream = MockNewWordStream()
        let model = NewWordModelImpl(
            langRepository: MockLangRepository(allLangsValue: []),
            newWordStream: mockNewWordStream,
            logger: LoggerStub()
        )

        mockNewWordStream.methodMock = { callsNumber += 1 }

        // Act
        model.sendNewWord(Word(text: "a", sourceLang: lang, targetLang: lang))

        // Assert
        XCTAssertEqual(callsNumber, 1)
    }
}
