//
//  WordListModelImplTests.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 05.03.2023.
//

import RxBlocking
import RxSwift
import XCTest
@testable import PersonalDictionary

final class WordListModelImplTests: XCTestCase {

    let lang = Lang(id: .init(raw: 1), name: "A", shortName: "a")
    lazy var word = Word(text: "abc", sourceLang: lang, targetLang: lang)
    lazy var word1 = Word(text: "a", sourceLang: lang, targetLang: lang)
    lazy var word2 = Word(text: "b", dictionaryEntry: ["y"], sourceLang: lang, targetLang: lang)
    lazy var word3 = Word(text: "c", sourceLang: lang, targetLang: lang)
    lazy var wordList = [word1, word2, word3]

    var updateWordDbWorkerMock: UpdateWordDbWorkerMock!
    var deleteWordDbWorkerMock: DeleteWordDbWorkerMock!
    var wordSenderMock: RUWordStreamMock!
    var dictionaryServiceMock: DictionaryServiceMock!
    var model: WordListModelImpl!

    func arrange() {
        updateWordDbWorkerMock = .init()
        deleteWordDbWorkerMock = .init()
        wordSenderMock = .init()
        dictionaryServiceMock = .init()
        model = .init(
            updateWordDbWorker: updateWordDbWorkerMock,
            deleteWordDbWorker: deleteWordDbWorkerMock,
            wordSender: wordSenderMock,
            dictionaryService: dictionaryServiceMock,
            intervalMs: 0
        )
    }

    func test_removeWord_returnsCorrectWordListState() throws {
        // Arrange
        arrange()

        // Act
        let newWordList = model.remove(at: 1, state: wordList)

        // Assert
        XCTAssertEqual(newWordList, [word1, word3])
    }

    func test_removeEffect_worksCorrectlyForHappyPath() throws {
        // Arrange
        arrange()

        var dbRequestCounter = 0
        var notificationCounter = 0

        deleteWordDbWorkerMock.deleteWordMock = { word in
            dbRequestCounter += 1
            return Single.just(word)
        }
        wordSenderMock.sendRemovedWordMock = { _ in notificationCounter += 1 }

        // Act
        let nextState = try model.removeEffect(word, state: wordList).toBlocking().first()

        // Assert
        XCTAssertEqual(nextState, wordList)
        XCTAssertEqual(dbRequestCounter, 1)
        XCTAssertEqual(notificationCounter, 1)
    }

    func test_removeEffect_failsWhenDbRemoveWordFails() throws {
        // Arrange
        arrange()

        deleteWordDbWorkerMock.deleteWordMock = { _ in Single.error(ErrorMock.err) }

        // Act
        let single = model.removeEffect(word, state: wordList)

        // Assert
        XCTAssertThrowsError(try single.toBlocking().first())
    }

    func test_updateWord_returnsCorrectWordListState() throws {
        // Arrange
        arrange()

        // Act
        let newWordList = model.update(word, at: 2, state: wordList)

        // Assert
        XCTAssertEqual(newWordList, [word1, word2, word])
    }

    func test_updateEffect_worksCorrectlyForHappyPath() throws {
        // Arrange
        arrange()

        var notificationCounter = 0
        var dbUpdateCounter = 0

        updateWordDbWorkerMock.updateWordMock = { (word: Word) in
            dbUpdateCounter += 1
            return Single.just(word)
        }
        wordSenderMock.sendUpdatedWordMock = { _ in notificationCounter += 1 }

        // Act
        let newState = try model.updateEffect(word, state: wordList).toBlocking().first()

        // Assert
        XCTAssertEqual(newState, wordList)
        XCTAssertEqual(notificationCounter, 1)
        XCTAssertEqual(dbUpdateCounter, 1)
    }

    func test_updateEffect_failsWhenDbRemoveWordFails() throws {
        // Arrange
        arrange()
        updateWordDbWorkerMock.updateWordMock = { _ in Single.error(ErrorMock.err) }

        // Act
        let single = model.updateEffect(word, state: [word, word2])

        // Assert
        XCTAssertThrowsError(try single.toBlocking().first())
    }

    func test_fetchTranslationsFor_emptyArrayArgument_returnsSingleOfEmptyArray() throws {
        // Arrange
        arrange()

        dictionaryServiceMock.fetchDictionaryEntryMock = { word in Single.just(word) }
        updateWordDbWorkerMock.updateWordMock = { word in Single.just(word) }

        // Act
        let result = try model.fetchTranslationsFor(state: [], start: 0, end: 1).toBlocking().first()

        // Assert
        XCTAssertEqual(result, [])
    }

    func test_fetchTranslationsFor_worksCorrectlyForHappyPath() throws {
        // Arrange
        arrange()

        var dbUpdateCounter = 0
        var translatedWord1 = word1
        var translatedWord3 = word3

        translatedWord1.dictionaryEntry = ["x"]
        translatedWord3.dictionaryEntry = ["z"]
        dictionaryServiceMock.fetchDictionaryEntryMock = { word in word == self.word1 ? Single.just(translatedWord1) :
            Single.just(translatedWord3) }
        updateWordDbWorkerMock.updateWordMock = { (word: Word) in
            dbUpdateCounter += 1
            return Single.just(word)
        }

        // Act
        let result = try model.fetchTranslationsFor(state: wordList, start: 0, end: 3).toBlocking().first()!

        // Assert
        XCTAssertEqual(dbUpdateCounter, 2)
        XCTAssertEqual(result, [translatedWord1, word2, translatedWord3])
    }

    func test_fetchTranslationsFor_failsWhenTranslationApiFails() throws {
        // Arrange
        arrange()

        dictionaryServiceMock.fetchDictionaryEntryMock = { _ in Single.error(ErrorMock.err) }

        // Act
        let observable = model.fetchTranslationsFor(state: wordList, start: 0, end: 3)

        // Assert
        XCTAssertThrowsError(try observable.toBlocking().toArray())
    }

    func test_fetchTranslationsFor_returnsCurrentStateWhenAllWordsAreTranslated() throws {
        // Arrange
        arrange()

        let translated = [Word(text: "a", dictionaryEntry: ["x"], sourceLang: lang, targetLang: lang),
                          Word(text: "b", dictionaryEntry: ["y"], sourceLang: lang, targetLang: lang),
                          Word(text: "c", dictionaryEntry: ["z"], sourceLang: lang, targetLang: lang)]

        // Act
        let result = try model.fetchTranslationsFor(state: translated, start: 0, end: 3).toBlocking().first()

        // Assert
        XCTAssertEqual(result, translated)
    }
}
