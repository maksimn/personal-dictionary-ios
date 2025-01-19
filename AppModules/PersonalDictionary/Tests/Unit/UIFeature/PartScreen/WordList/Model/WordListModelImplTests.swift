//
//  WordListModelImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 05.03.2023.
//

import RxSwift
import XCTest
@testable import PersonalDictionary

final class WordListModelImplTests: XCTestCase {

    var model: WordListModelImpl!

    var updateWordDbWorkerMock: UpdateWordDbWorkerMock!
    var deleteWordDbWorkerMock: DeleteWordDbWorkerMock!
    var updatedWordSenderMock: UpdatedWordSenderMock!
    var removedWordSenderMock: RemovedWordSenderMock!

    let lang = Lang.defaultValueFUT
    lazy var word = Word(text: "abc", sourceLang: lang, targetLang: lang)
    lazy var newWord = Word(id: word.id, text: "ab", sourceLang: lang, targetLang: lang)
    lazy var word1 = Word(text: "a", sourceLang: lang, targetLang: lang)
    lazy var word2 = Word(text: "b", translation: "y", sourceLang: lang, targetLang: lang)
    lazy var word3 = Word(text: "c", sourceLang: lang, targetLang: lang)
    lazy var updatedWord = UpdatedWord(newValue: newWord, oldValue: word)
    lazy var wordList = [word1, word2, word3]

    func arrange() {
        updateWordDbWorkerMock = .init()
        deleteWordDbWorkerMock = .init()
        updatedWordSenderMock = .init()
        removedWordSenderMock = .init()
        model = .init(
            updateWordDbWorker: updateWordDbWorkerMock,
            deleteWordDbWorker: deleteWordDbWorkerMock,
            updatedWordSender: updatedWordSenderMock,
            removedWordSender: removedWordSenderMock
        )
    }

    func test_removeAt_returnsCorrectWordListState() throws {
        // Arrange
        arrange()

        // Act
        let newWordList = try model.remove(at: 1, state: wordList).toBlocking().first()!

        // Assert
        XCTAssertEqual(newWordList, [word1, word3])
    }

    func test_removeWord_returnsCorrectNextState() throws {
        // Arrange
        arrange()

        // Act
        let nextState = try model.remove(word: word, state: wordList).toBlocking().first()

        // Assert
        XCTAssertEqual(nextState, wordList)
    }

    func test_removeAt_removesWordFromDB() throws {
        // Arrange
        arrange()

        var dbRequestCounter = 0

        deleteWordDbWorkerMock.deleteWordMock = {
            dbRequestCounter += 1
            return Single.just($0)
        }

        // Act
        _ = try model.remove(at: 1, state: wordList).toBlocking().first()

        // Assert
        XCTAssertEqual(dbRequestCounter, 1)
    }

    func test_removeAt_sendsNotificationAboutRemovedWord() throws {
        // Arrange
        arrange()

        var notificationCounter = 0

        removedWordSenderMock.sendRemovedWordMock = { _ in notificationCounter += 1 }

        // Act
        _ = try model.remove(at: 1, state: wordList).toBlocking().first()

        // Assert
        XCTAssertEqual(notificationCounter, 1)
    }

    func test_removeAt_failsWhenDbRemoveWordFails() throws {
        // Arrange
        arrange()
        deleteWordDbWorkerMock.deleteWordMock = { _ in Single.error(ErrorMock.err) }

        // Act
        let single = model.remove(at: 1, state: wordList)

        // Assert
        XCTAssertThrowsError(try single.toBlocking().first())
    }

    func test_toggleIsFavorite_returnsCorrectWordListState() throws {
        // Arrange
        arrange()

        var updatedWord2 = word2

        updatedWord2.isFavorite.toggle()

        // Act
        let newWordList = try model.toggleIsFavorite(at: 1, state: wordList).toBlocking().first()

        // Assert
        XCTAssertEqual(newWordList, [word1, updatedWord2, word3])
    }

    func test_updateWord_returnsCorrectNextState() throws {
        // Arrange
        arrange()

        // Act
        let newState = try model.update(word: updatedWord, state: [word, word2, word3]).toBlocking().first()!

        // Assert
        XCTAssertEqual(newState, [newWord, word2, word3])
    }

    func test_toggleIsFavorite_updatesWordInDB() throws {
        // Arrange
        arrange()

        var dbUpdateCounter = 0

        updateWordDbWorkerMock.updateWordMock = {
            dbUpdateCounter += 1
            return Single.just($0)
        }

        // Act
        _ = try model.toggleIsFavorite(at: 1, state: wordList).toBlocking().first()

        // Assert
        XCTAssertEqual(dbUpdateCounter, 1)
    }

    func test_toggleIsFavorite_sendsNotificationAboutUpdatedWord() throws {
        // Arrange
        arrange()

        var notificationCounter = 0

        updatedWordSenderMock.sendUpdatedWordMock = { _ in notificationCounter += 1 }

        // Act
        _ = try model.toggleIsFavorite(at: 1, state: wordList).toBlocking().first()

        // Assert
        XCTAssertEqual(notificationCounter, 1)
    }

    func test_toggleIsFavorite_failsWhenDbRemoveWordFails() throws {
        // Arrange
        arrange()
        updateWordDbWorkerMock.updateWordMock = { _ in Single.error(ErrorMock.err) }

        // Act
        let single = model.toggleIsFavorite(at: 1, state: wordList)

        // Assert
        XCTAssertThrowsError(try single.toBlocking().first())
    }
}
