//
//  WordListModelImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 05.03.2023.
//

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

    func test_removeAt_returnsCorrectWordListState() async throws {
        // Arrange
        arrange()

        // Act
        let newWordList = try await model.remove(at: 1, state: wordList)

        // Assert
        XCTAssertEqual(newWordList, [word1, word3])
    }

    func test_removeWord_returnsCorrectNextState() async throws {
        // Arrange
        arrange()

        // Act
        let nextState = try await model.remove(word: word, state: wordList)

        // Assert
        XCTAssertEqual(nextState, wordList)
    }

    func test_removeAt_removesWordFromDB() async throws {
        // Arrange
        arrange()

        var dbRequestCounter = 0

        deleteWordDbWorkerMock.deleteWordMock = {
            dbRequestCounter += 1
            return $0
        }

        // Act
        _ = try await model.remove(at: 1, state: wordList)

        // Assert
        XCTAssertEqual(dbRequestCounter, 1)
    }

    func test_removeAt_sendsNotificationAboutRemovedWord() async throws {
        // Arrange
        arrange()

        var notificationCounter = 0

        removedWordSenderMock.sendRemovedWordMock = { _ in notificationCounter += 1 }

        // Act
        _ = try await model.remove(at: 1, state: wordList)

        // Assert
        XCTAssertEqual(notificationCounter, 1)
    }

    func test_removeAt_failsWhenDbRemoveWordFails() async throws {
        // Arrange
        arrange()
        deleteWordDbWorkerMock.deleteWordMock = { _ in throw ErrorMock.err }

        // Act & Assert
        do {
            _ = try await model.remove(at: 1, state: wordList)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? ErrorMock, ErrorMock.err)
        }
    }

    func test_toggleIsFavorite_returnsCorrectWordListState() async throws {
        // Arrange
        arrange()

        var updatedWord2 = word2

        updatedWord2.isFavorite.toggle()

        // Act
        let newWordList = try await model.toggleIsFavorite(at: 1, state: wordList)

        // Assert
        XCTAssertEqual(newWordList, [word1, updatedWord2, word3])
    }

    func test_updateWord_returnsCorrectNextState() async throws {
        // Arrange
        arrange()

        // Act
        let newState = try await model.update(word: updatedWord, state: [word, word2, word3])

        // Assert
        XCTAssertEqual(newState, [newWord, word2, word3])
    }

    func test_toggleIsFavorite_updatesWordInDB() async throws {
        // Arrange
        arrange()

        var dbUpdateCounter = 0

        updateWordDbWorkerMock.updateWordMock = {
            dbUpdateCounter += 1
            return $0
        }

        // Act
        _ = try await model.toggleIsFavorite(at: 1, state: wordList)

        // Assert
        XCTAssertEqual(dbUpdateCounter, 1)
    }

    func test_toggleIsFavorite_sendsNotificationAboutUpdatedWord() async throws {
        // Arrange
        arrange()

        var notificationCounter = 0

        updatedWordSenderMock.sendUpdatedWordMock = { _ in notificationCounter += 1 }

        // Act
        _ = try await model.toggleIsFavorite(at: 1, state: wordList)

        // Assert
        XCTAssertEqual(notificationCounter, 1)
    }

    func test_toggleIsFavorite_failsWhenDbRemoveWordFails() async throws {
        // Arrange
        arrange()
        updateWordDbWorkerMock.updateWordMock = { _ in throw ErrorMock.err }

        // Act & Assert
        do {
            _ = try await model.toggleIsFavorite(at: 1, state: wordList)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? ErrorMock, ErrorMock.err)
        }
    }
}
