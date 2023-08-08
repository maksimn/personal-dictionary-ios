//
//  MainWordListModelImplTests.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.03.2023.
//

import RxSwift
import XCTest
@testable import PersonalDictionary

final class MainWordListModelImplTests: XCTestCase {

    let lang = Lang(id: .init(raw: 1), name: "A", shortName: "a")
    lazy var word = Word(text: "abc", sourceLang: lang, targetLang: lang)
    lazy var word1 = Word(text: "a", sourceLang: lang, targetLang: lang)
    lazy var word2 = Word(text: "b", dictionaryEntry: ["y"], sourceLang: lang, targetLang: lang)
    lazy var word3 = Word(text: "c", sourceLang: lang, targetLang: lang)
    lazy var wordList = [word1, word2, word3]

    var wordListFetcherMock: WordListFetcherMock!
    var translationServiceMock: TranslationServiceMock!
    var createWordDbWorkerMock: CreateWordDbWorkerMock!
    var updateWordDbWorkerMock: UpdateWordDbWorkerMock!
    var model: MainWordListModelImpl!

    func arrange() {
        wordListFetcherMock = WordListFetcherMock()
        createWordDbWorkerMock = CreateWordDbWorkerMock()
        updateWordDbWorkerMock = UpdateWordDbWorkerMock()
        translationServiceMock = TranslationServiceMock()
        model = MainWordListModelImpl(
            wordListFetcher: wordListFetcherMock,
            сreateWordDbWorker: createWordDbWorkerMock,
            updateWordDbWorker: updateWordDbWorkerMock,
            translationService: translationServiceMock
        )
    }

    func test_fetchMainWordList_worksCorrectly() throws {
        // Arrange
        arrange()
        wordListFetcherMock.wordListMock = { self.wordList }

        // Act
        let fetchedWordList = model.fetchMainWordList()

        // Assert
        XCTAssertEqual(fetchedWordList, wordList)
    }

    func test_createWord_returnsCorrectWordListState() throws {
        // Arrange
        arrange()

        // Act
        let newWordList = model.create(word, state: wordList)

        // Assert
        XCTAssertEqual(newWordList, [word, word1, word2, word3])
    }

    func test_createEffect_worksCorrectlyForHappyPath() throws {
        // Arrange
        arrange()

        var dbUpdateCounter = 0
        let translatedWord = Word(text: "abc", dictionaryEntry: ["translation"], sourceLang: lang, targetLang: lang)

        createWordDbWorkerMock.createWordMock = { word in Single.just(word) }
        updateWordDbWorkerMock.updateWordMock = { (word: Word) in
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
        arrange()
        createWordDbWorkerMock.createWordMock = { _ in Single.error(ErrorMock.err) }

        // Act
        let single = model.createEffect(word, state: wordList)

        // Assert
        XCTAssertThrowsError(try single.toBlocking().first())
    }
}
