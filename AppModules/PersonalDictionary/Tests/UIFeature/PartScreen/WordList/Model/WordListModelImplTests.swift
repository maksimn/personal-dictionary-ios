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
        mockCudOperations.mockUpdateMethod = { (word: Word) in
            dbUpdateCounter += 1
            return Single.just(word)
        }
        mockTranslationService.mockMethod = { Single.just(translatedWord) }

        // Act
        let resultWord = try model.create(word).toBlocking().first()

        // Assert
        XCTAssertEqual(dbUpdateCounter, 1)
        XCTAssertEqual(resultWord, translatedWord)
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

        mockCudOperations.mockUpdateMethod = { (word: Word) in
            dbUpdateCounter += 1
            return Single.just(word)
        }
        mockWordStream.mockSendUpdatedWord = { counter += 1 }

        // Act
        _ = try model.update(word).toBlocking().first()

        // Assert
        XCTAssertEqual(counter, 1)
        XCTAssertEqual(dbUpdateCounter, 1)
    }

    func test_fetchTranslationsFor_worksCorrectlyForHappyPath() throws {
        // Arrange
        var dbUpdateCounter = 0
        let mockCudOperations = MockWordCUDOperations()
        let mockWordStream = MockRUWordStream()
        let mockTranslationService = MockTranslationService()
        let model = WordListModelImpl(
            cudOperations: mockCudOperations,
            wordStream: mockWordStream,
            translationService: mockTranslationService,
            intervalMs: 0
        )
        let word1 = Word(text: "a", sourceLang: lang, targetLang: lang)
        let word2 = Word(text: "b", translation: "y", sourceLang: lang, targetLang: lang)
        let word3 = Word(text: "c", sourceLang: lang, targetLang: lang)
        let words = [word1, word2, word3]
        var translatedWord1 = word1
        var translatedWord3 = word3

        translatedWord1.translation = "x"
        translatedWord3.translation = "z"

        var i = 0
        mockTranslationService.mockMethod = {
            if i == 0 {
                i += 1
                return Single.just(translatedWord1)
            }
            return Single.just(translatedWord3)
        }
        mockCudOperations.mockUpdateMethod = { (word: Word) in
            dbUpdateCounter += 1
            return Single.just(word)
        }

        // Act
        let result = try model.fetchTranslationsFor(words, start: 0, end: 3).toBlocking().toArray()

        // Assert
        XCTAssertEqual(dbUpdateCounter, 2)
        XCTAssertEqual(result, [translatedWord1, translatedWord3])
    }
}
