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
    lazy var word1 = Word(text: "a", sourceLang: lang, targetLang: lang)
    lazy var word2 = Word(text: "b", translation: "y", sourceLang: lang, targetLang: lang)
    lazy var word3 = Word(text: "c", sourceLang: lang, targetLang: lang)
    lazy var wordList = [word1, word2, word3]

    func test_createWord_returnsCorrectWordListState() throws {
        // Arrange
        let model = WordListModelImpl(
            cudOperations: WordCUDOperationsMock(),
            wordStream: RUWordStreamMock(),
            translationService: TranslationServiceMock()
        )

        // Act
        let newWordList = model.create(word, state: wordList)

        // Assert
        XCTAssertEqual(newWordList, [word, word1, word2, word3])
    }

    func test_createEffect_worksCorrectlyForHappyPath() throws {
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
        let nextState = try model.createEffect(word, state: [word, word1, word2, word3]).toBlocking().first()

        // Assert
        XCTAssertEqual(dbUpdateCounter, 1)
        XCTAssertEqual(nextState, [translatedWord, word1, word2, word3])
    }

    func test_createEffect_failsWhenDbCreateWordFails() throws {
        // Arrange
        let cudOperationsMock = WordCUDOperationsMock()
        let model = WordListModelImpl(
            cudOperations: cudOperationsMock,
            wordStream: RUWordStreamMock(),
            translationService: TranslationServiceMock()
        )

        cudOperationsMock.addWordMock = { word in Single.error(ErrorMock.err) }

        // Act
        let single = model.createEffect(word, state: wordList)

        // Assert
        XCTAssertThrowsError(try single.toBlocking().first())
    }

    func test_removeWord_returnsCorrectWordListState() throws {
        // Arrange
        let model = WordListModelImpl(
            cudOperations: WordCUDOperationsMock(),
            wordStream: RUWordStreamMock(),
            translationService: TranslationServiceMock()
        )

        // Act
        let newWordList = model.remove(at: 1, state: wordList)

        // Assert
        XCTAssertEqual(newWordList, [word1, word3])
    }

    func test_removeEffect_worksCorrectlyForHappyPath() throws {
        // Arrange
        var dbRequestCounter = 0
        var notificationCounter = 0
        let cudOperationsMock = WordCUDOperationsMock()
        let wordStreamMock = RUWordStreamMock()
        let translationServiceMock = TranslationServiceMock()
        let model = WordListModelImpl(
            cudOperations: cudOperationsMock,
            wordStream: wordStreamMock,
            translationService: translationServiceMock
        )

        cudOperationsMock.removeWordMock = { word in
            dbRequestCounter += 1
            return Single.just(word)
        }
        wordStreamMock.sendRemovedWordMock = { _ in notificationCounter += 1 }

        // Act
        let nextState = try model.removeEffect(word, state: wordList).toBlocking().first()

        // Assert
        XCTAssertEqual(nextState, wordList)
        XCTAssertEqual(dbRequestCounter, 1)
        XCTAssertEqual(notificationCounter, 1)
    }

    func test_removeEffect_failsWhenDbRemoveWordFails() throws {
        // Arrange
        let cudOperationsMock = WordCUDOperationsMock()
        let model = WordListModelImpl(
            cudOperations: cudOperationsMock,
            wordStream: RUWordStreamMock(),
            translationService: TranslationServiceMock()
        )

        cudOperationsMock.removeWordMock = { word in Single.error(ErrorMock.err) }

        // Act
        let single = model.removeEffect(word, state: wordList)

        // Assert
        XCTAssertThrowsError(try single.toBlocking().first())
    }

    func test_updateWord_returnsCorrectWordListState() throws {
        // Arrange
        let model = WordListModelImpl(
            cudOperations: WordCUDOperationsMock(),
            wordStream: RUWordStreamMock(),
            translationService: TranslationServiceMock()
        )

        // Act
        let newWordList = model.update(word, at: 2, state: wordList)

        // Assert
        XCTAssertEqual(newWordList, [word1, word2, word])
    }

    func test_updateEffect_worksCorrectlyForHappyPath() throws {
        // Arrange
        var notificationCounter = 0
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
        wordStreamMock.sendUpdatedWordMock = { _ in notificationCounter += 1 }

        // Act
        let newState = try model.updateEffect(word, state: wordList).toBlocking().first()

        // Assert
        XCTAssertEqual(newState, wordList)
        XCTAssertEqual(notificationCounter, 1)
        XCTAssertEqual(dbUpdateCounter, 1)
    }

    func test_updateEffect_failsWhenDbRemoveWordFails() throws {
        // Arrange
        let cudOperationsMock = WordCUDOperationsMock()
        let model = WordListModelImpl(
            cudOperations: cudOperationsMock,
            wordStream: RUWordStreamMock(),
            translationService: TranslationServiceMock()
        )

        cudOperationsMock.updateWordMock = { word in Single.error(ErrorMock.err) }

        // Act
        let single = model.updateEffect(word, state: [word, word2])

        // Assert
        XCTAssertThrowsError(try single.toBlocking().first())
    }

    func test_fetchTranslationsFor_emptyArrayArgument_returnsSingleOfEmptyArray() throws {
        // Arrange
        let cudOperationsMock = WordCUDOperationsMock()
        let translationServiceMock = TranslationServiceMock()
        let model = WordListModelImpl(
            cudOperations: cudOperationsMock,
            wordStream: RUWordStreamMock(),
            translationService: translationServiceMock,
            intervalMs: 0
        )
        translationServiceMock.methodMock = { word in Single.just(word) }
        cudOperationsMock.updateWordMock = { word in Single.just(word) }

        // Act
        let result = try model.fetchTranslationsFor(state: [], start: 0, end: 1).toBlocking().first()

        // Assert
        XCTAssertEqual(result, [])
    }

    func test_fetchTranslationsFor_worksCorrectlyForHappyPath() throws {
        // Arrange
        var dbUpdateCounter = 0
        let cudOperationsMock = WordCUDOperationsMock()
        let translationServiceMock = TranslationServiceMock()
        let model = WordListModelImpl(
            cudOperations: cudOperationsMock,
            wordStream: RUWordStreamMock(),
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
        let result = try model.fetchTranslationsFor(state: words, start: 0, end: 3).toBlocking().toArray()

        // Assert
        XCTAssertEqual(dbUpdateCounter, 2)
        XCTAssertEqual(result.last!, [translatedWord1, word2, translatedWord3])
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
        let observable = model.fetchTranslationsFor(state: [word1, word2, word3], start: 0, end: 3)

        // Assert
        XCTAssertThrowsError(try observable.toBlocking().toArray())
    }
}
