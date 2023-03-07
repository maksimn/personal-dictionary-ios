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
    lazy var word = Word(text: "abc", sourceLang: lang, targetLang: lang)

    func test_createWord_worksCorrectlyForHappyPath() throws {
        // Arrange
        var dbUpdateCounter = 0
        let cudOperationsMock = WordCUDOperationsMock()
        let wordStreamMock = RUWordStreamMock()
        let translationServiceMock = TranslationServiceMock()
        let model = WordListModelImpl(
            cudOperations: cudOperationsMock,
            wordStream: wordStreamMock,
            translationService: translationServiceMock
        )
        let translatedWord = Word(text: "abc", translation: "translation", sourceLang: lang, targetLang: lang)

        cudOperationsMock.addWordMock = { word in Single.just(word) }
        cudOperationsMock.updateWordMock = { (word: Word) in
            dbUpdateCounter += 1
            return Single.just(word)
        }
        translationServiceMock.methodMock = { _ in Single.just(translatedWord) }

        // Act
        let resultWord = try model.create(word).toBlocking().first()

        // Assert
        XCTAssertEqual(dbUpdateCounter, 1)
        XCTAssertEqual(resultWord, translatedWord)
    }

    func test_createWord_failsWhenDbCreateWordFails() throws {
        // Arrange
        let cudOperationsMock = WordCUDOperationsMock()
        let model = WordListModelImpl(
            cudOperations: cudOperationsMock,
            wordStream: RUWordStreamMock(),
            translationService: TranslationServiceMock()
        )

        cudOperationsMock.addWordMock = { word in Single.error(ErrorMock.err) }

        // Act
        let single = model.create(word)

        // Assert
        XCTAssertThrowsError(try single.toBlocking().first())
    }

    func test_removeWord_worksCorrectlyForHappyPath() throws {
        // Arrange
        let cudOperationsMock = WordCUDOperationsMock()
        let wordStreamMock = RUWordStreamMock()
        let translationServiceMock = TranslationServiceMock()
        let model = WordListModelImpl(
            cudOperations: cudOperationsMock,
            wordStream: wordStreamMock,
            translationService: translationServiceMock
        )

        cudOperationsMock.removeWordMock = { word in Single.just(word) }
        wordStreamMock.sendRemovedWordMock = { _ in }

        // Act
        let removedWord = try model.remove(word).toBlocking().first()

        // Assert
        XCTAssertEqual(removedWord, word)
    }

    func test_removeWord_failsWhenDbRemoveWordFails() throws {
        // Arrange
        let cudOperationsMock = WordCUDOperationsMock()
        let model = WordListModelImpl(
            cudOperations: cudOperationsMock,
            wordStream: RUWordStreamMock(),
            translationService: TranslationServiceMock()
        )

        cudOperationsMock.removeWordMock = { word in Single.error(ErrorMock.err) }

        // Act
        let single = model.remove(word)

        // Assert
        XCTAssertThrowsError(try single.toBlocking().first())
    }

    func test_updateWord_worksCorrectlyForHappyPath() throws {
        // Arrange
        var counter = 0
        var dbUpdateCounter = 0
        let cudOperationsMock = WordCUDOperationsMock()
        let wordStreamMock = RUWordStreamMock()
        let translationServiceMock = TranslationServiceMock()
        let model = WordListModelImpl(
            cudOperations: cudOperationsMock,
            wordStream: wordStreamMock,
            translationService: translationServiceMock
        )

        cudOperationsMock.updateWordMock = { (word: Word) in
            dbUpdateCounter += 1
            return Single.just(word)
        }
        wordStreamMock.sendUpdatedWordMock = { _ in counter += 1 }

        // Act
        _ = try model.update(word).toBlocking().first()

        // Assert
        XCTAssertEqual(counter, 1)
        XCTAssertEqual(dbUpdateCounter, 1)
    }

    func test_updateWord_failsWhenDbRemoveWordFails() throws {
        // Arrange
        let cudOperationsMock = WordCUDOperationsMock()
        let model = WordListModelImpl(
            cudOperations: cudOperationsMock,
            wordStream: RUWordStreamMock(),
            translationService: TranslationServiceMock()
        )

        cudOperationsMock.updateWordMock = { word in Single.error(ErrorMock.err) }

        // Act
        let single = model.update(word)

        // Assert
        XCTAssertThrowsError(try single.toBlocking().first())
    }

    func test_fetchTranslationsFor_worksCorrectlyForHappyPath() throws {
        // Arrange
        var dbUpdateCounter = 0
        let cudOperationsMock = WordCUDOperationsMock()
        let wordStreamMock = RUWordStreamMock()
        let translationServiceMock = TranslationServiceMock()
        let model = WordListModelImpl(
            cudOperations: cudOperationsMock,
            wordStream: wordStreamMock,
            translationService: translationServiceMock,
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
        translationServiceMock.methodMock = { _ in
            i += 1
            return i == 1 ? Single.just(translatedWord1) : Single.just(translatedWord3)
        }
        cudOperationsMock.updateWordMock = { (word: Word) in
            dbUpdateCounter += 1
            return Single.just(word)
        }

        // Act
        let result = try model.fetchTranslationsFor(words, start: 0, end: 3).toBlocking().toArray()

        // Assert
        XCTAssertEqual(dbUpdateCounter, 2)
        XCTAssertEqual(result, [translatedWord1, translatedWord3])
    }

    func test_fetchTranslationsFor_failsWhenTranslationApiFails() throws {
        // Arrange
        let translationServiceMock = TranslationServiceMock()
        let model = WordListModelImpl(
            cudOperations: WordCUDOperationsMock(),
            wordStream: RUWordStreamMock(),
            translationService: translationServiceMock,
            intervalMs: 0
        )
        let word1 = Word(text: "a", sourceLang: lang, targetLang: lang)
        let word2 = Word(text: "b", translation: "y", sourceLang: lang, targetLang: lang)
        let word3 = Word(text: "c", sourceLang: lang, targetLang: lang)

        translationServiceMock.methodMock = { _ in Single.error(ErrorMock.err) }

        // Act
        let observable = model.fetchTranslationsFor([word1, word2, word3], start: 0, end: 3)

        // Assert
        XCTAssertThrowsError(try observable.toBlocking().toArray())
    }
}
