//
//  WordListModelImplTests.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 05.03.2023.
//

import RxSwift
import XCTest
@testable import PersonalDictionary

final class WordListModelImplTests: XCTestCase {

    let lang = Lang(id: .init(raw: 1), name: "A", shortName: "a")

    func test_createWord_worksCorrectlyForHappyPath() throws {
        // Arrange
        var counter = 0
        var dbUpdateCounter = 0
        let mockCudOperations = MockWordCUDOperations()
        let mockWordStream = MockRUWordStream()
        let mockTranslationService = MockTranslationService()
        let model = WordListModelImpl(
            cudOperations: mockCudOperations,
            wordStream: mockWordStream,
            translationService: mockTranslationService
        )
        let word = Word(text: "abc", sourceLang: lang, targetLang: lang)
        let translatedWord = Word(text: "abc", translation: "translation", sourceLang: lang, targetLang: lang)

        mockCudOperations.mockAddResult = Single.just(word)
        mockCudOperations.mockUpdateResult = Single.just(translatedWord)
        mockCudOperations.mockUpdateCall = { dbUpdateCounter += 1 }
        mockTranslationService.mockResult = Single.just(translatedWord)
        mockWordStream.mockSendUpdatedWord = { counter += 1 }

        // Act
        _ = try model.create(word).toBlocking().first()

        // Assert
        XCTAssertEqual(counter, 1)
        XCTAssertEqual(dbUpdateCounter, 1)
    }

    func test_removeWord_worksCorrectlyForHappyPath() throws {
        // Arrange
        var counter = 0
        let mockCudOperations = MockWordCUDOperations()
        let mockWordStream = MockRUWordStream()
        let mockTranslationService = MockTranslationService()
        let model = WordListModelImpl(
            cudOperations: mockCudOperations,
            wordStream: mockWordStream,
            translationService: mockTranslationService
        )
        let word = Word(text: "abc", sourceLang: lang, targetLang: lang)

        mockCudOperations.mockRemoveResult = Single.just(word)
        mockWordStream.mockSendRemovedWord = { counter += 1 }

        // Act
        _ = try model.remove(word).toBlocking().first()

        // Assert
        XCTAssertEqual(counter, 1)
    }

    func test_updateWord_worksCorrectlyForHappyPath() throws {
        // Arrange
        var counter = 0
        var dbUpdateCounter = 0
        let mockCudOperations = MockWordCUDOperations()
        let mockWordStream = MockRUWordStream()
        let mockTranslationService = MockTranslationService()
        let model = WordListModelImpl(
            cudOperations: mockCudOperations,
            wordStream: mockWordStream,
            translationService: mockTranslationService
        )
        let word = Word(text: "abc", sourceLang: lang, targetLang: lang)

        mockCudOperations.mockUpdateResult = Single.just(word)
        mockCudOperations.mockUpdateCall = { dbUpdateCounter += 1 }
        mockWordStream.mockSendUpdatedWord = { counter += 1 }

        // Act
        _ = try model.update(word).toBlocking().first()

        // Assert
        XCTAssertEqual(counter, 1)
        XCTAssertEqual(dbUpdateCounter, 1)
    }

    func test_fetchTranslationsFor_worksCorrectlyForHappyPath() throws {
        // Arrange
        var translationCallCounter = 0
        var dbUpdateCounter = 0
        var modelStreamCallCounter = 0
        let mockCudOperations = MockWordCUDOperations()
        let mockWordStream = MockRUWordStream()
        let mockTranslationService = MockTranslationService()
        let model = WordListModelImpl(
            cudOperations: mockCudOperations,
            wordStream: mockWordStream,
            translationService: mockTranslationService,
            intervalMs: 0
        )
        let words = [
            Word(text: "a", sourceLang: lang, targetLang: lang),
            Word(text: "b", translation: "y", sourceLang: lang, targetLang: lang),
            Word(text: "c", sourceLang: lang, targetLang: lang)
        ]
        let mockTranslatedWord = Word(text: "a", translation: "x", sourceLang: lang, targetLang: lang)

        mockTranslationService.mockResult = .just(mockTranslatedWord)
        mockTranslationService.mockMethodCall = { translationCallCounter += 1 }
        mockCudOperations.mockUpdateCall = { dbUpdateCounter += 1 }
        mockCudOperations.mockUpdateResult = .just(mockTranslatedWord)
        mockWordStream.mockSendUpdatedWord = { modelStreamCallCounter += 1 }

        // Act
        _ = try model.fetchTranslationsFor(words, start: 0, end: 3).toBlocking().first()

        // Assert
        XCTAssertEqual(translationCallCounter, 2)
        XCTAssertEqual(dbUpdateCounter, 2)
        XCTAssertEqual(modelStreamCallCounter, 2)
    }
}
