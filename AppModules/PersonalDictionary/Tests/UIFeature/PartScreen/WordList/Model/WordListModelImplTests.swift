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
    lazy var word2 = Word(text: "b", translation: "y", sourceLang: lang, targetLang: lang)
    lazy var word3 = Word(text: "c", sourceLang: lang, targetLang: lang)
    lazy var wordList = [word1, word2, word3]

    var updateWordDbWorkerMock: UpdateWordDbWorkerMock!
    var deleteWordDbWorkerMock: DeleteWordDbWorkerMock!
    var wordSenderMock: RUWordStreamMock!
    var model: WordListModelImpl!

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
}
