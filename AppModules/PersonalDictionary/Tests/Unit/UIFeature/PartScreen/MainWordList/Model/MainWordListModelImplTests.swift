//
//  MainWordListModelImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maxim Ivanov on 30.03.2023.
//

import XCTest
@testable import PersonalDictionary

final class MainWordListModelImplTests: XCTestCase {

    var model: MainWordListModelImpl!

    var wordListFetcherMock: WordListFetcherMock!
    var dictionaryServiceMock: DictionaryServiceMock!
    var createWordDbWorkerMock: CreateWordDbWorkerMock!

    let lang = Lang.defaultValueFUT
    lazy var word = Word(text: "abc", sourceLang: lang, targetLang: lang)
    lazy var word1 = Word(text: "a", sourceLang: lang, targetLang: lang)
    lazy var word2 = Word(text: "b", sourceLang: lang, targetLang: lang)
    lazy var word3 = Word(text: "c", sourceLang: lang, targetLang: lang)
    lazy var wordList = [word1, word2, word3]

    func arrange() {
        wordListFetcherMock = WordListFetcherMock()
        createWordDbWorkerMock = CreateWordDbWorkerMock()
        dictionaryServiceMock = DictionaryServiceMock()
        model = MainWordListModelImpl(
            wordListFetcher: wordListFetcherMock,
            сreateWordDbWorker: createWordDbWorkerMock,
            dictionaryService: dictionaryServiceMock
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

    func test_createEffect_worksCorrectlyForHappyPath() async throws {
        // Arrange
        arrange()

        let translatedWord = Word(id: word.id, text: word.text, translation: "xyz", sourceLang: word.sourceLang,
            targetLang: word.targetLang)

        createWordDbWorkerMock.createWordMock = { word in word }
        dictionaryServiceMock.fetchDictionaryEntryMock = { _ in
            WordData(word: translatedWord, entry: Data())
        }

        // Act
        let nextState = try await model.createEffect(word, state: [word, word1, word2, word3])

        // Assert
        XCTAssertEqual(nextState, [translatedWord, word1, word2, word3])
    }

    func test_createEffect_failsWhenDbCreateWordFails() async throws {
        // Arrange
        arrange()
        createWordDbWorkerMock.createWordMock = { _ in throw ErrorMock.err }

        // Act & Assert
        do {
            _ = try await model.createEffect(word, state: wordList)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? ErrorMock, ErrorMock.err)
        }
    }
}
