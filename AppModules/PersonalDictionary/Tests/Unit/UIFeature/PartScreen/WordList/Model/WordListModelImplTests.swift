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
    var wordSenderMock: RUWordStreamMock!

    let lang = Lang.defaultValueFUT
    lazy var word = Word(text: "abc", sourceLang: lang, targetLang: lang)
    lazy var oldWord = Word(id: word.id, text: "ab", sourceLang: lang, targetLang: lang)
    lazy var word1 = Word(text: "a", sourceLang: lang, targetLang: lang)
    lazy var word2 = Word(text: "b", translation: "y", sourceLang: lang, targetLang: lang)
    lazy var word3 = Word(text: "c", sourceLang: lang, targetLang: lang)
    lazy var updatedWord = UpdatedWord(newValue: word, oldValue: oldWord)
    lazy var wordList = [word1, word2, word3]

    func arrange() {
        updateWordDbWorkerMock = .init()
        deleteWordDbWorkerMock = .init()
        wordSenderMock = .init()
        model = .init(
            updateWordDbWorker: updateWordDbWorkerMock,
            deleteWordDbWorker: deleteWordDbWorkerMock,
            wordSender: wordSenderMock
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

    func test_removeEffect_returnsCorrectNextState() throws {
        // Arrange
        arrange()

        // Act
        let nextState = try model.removeEffect(word, state: wordList).toBlocking().first()

        // Assert
        XCTAssertEqual(nextState, wordList)
    }

    func test_removeEffect_removesWordFromDB() throws {
        // Arrange
        arrange()

        var dbRequestCounter = 0

        deleteWordDbWorkerMock.deleteWordMock = {
            dbRequestCounter += 1
            return Single.just($0)
        }

        // Act
        _ = try model.removeEffect(word, state: wordList).toBlocking().first()

        // Assert
        XCTAssertEqual(dbRequestCounter, 1)
    }

    func test_removeEffect_sendsNotificationAboutRemovedWord() throws {
        // Arrange
        arrange()

        var notificationCounter = 0

        wordSenderMock.sendRemovedWordMock = { _ in notificationCounter += 1 }

        // Act
        _ = try model.removeEffect(word, state: wordList).toBlocking().first()

        // Assert
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

    func test_updateEffect_returnsCorrectNextState() throws {
        // Arrange
        arrange()

        // Act
        let newState = try model.updateEffect(updatedWord, state: wordList).toBlocking().first()

        // Assert
        XCTAssertEqual(newState, wordList)
    }

    func test_updateEffect_updatesWordInDB() throws {
        // Arrange
        arrange()

        var dbUpdateCounter = 0

        updateWordDbWorkerMock.updateWordMock = {
            dbUpdateCounter += 1
            return Single.just($0)
        }

        // Act
        _ = try model.updateEffect(updatedWord, state: wordList).toBlocking().first()

        // Assert
        XCTAssertEqual(dbUpdateCounter, 1)
    }

    func test_updateEffect_sendsNotificationAboutUpdatedWord() throws {
        // Arrange
        arrange()

        var notificationCounter = 0

        wordSenderMock.sendUpdatedWordMock = { _ in notificationCounter += 1 }

        // Act
        _ = try model.updateEffect(updatedWord, state: wordList).toBlocking().first()

        // Assert
        XCTAssertEqual(notificationCounter, 1)
    }

    func test_updateEffect_failsWhenDbRemoveWordFails() throws {
        // Arrange
        arrange()
        updateWordDbWorkerMock.updateWordMock = { _ in Single.error(ErrorMock.err) }

        // Act
        let single = model.updateEffect(updatedWord, state: [word, word2])

        // Assert
        XCTAssertThrowsError(try single.toBlocking().first())
    }
}
