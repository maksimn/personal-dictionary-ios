//
//  WordListRepositoryImpTests.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import RealmSwift
import RxBlocking
import XCTest
@testable import PersonalDictionary

class WordListRepositoryImpTests: XCTestCase {

    let langOne = Lang(id: .init(raw: 1), name: "Aa", shortName: "a")
    let langTwo = Lang(id: .init(raw: 2), name: "Bb", shortName: "b")

    lazy var word1 = Word(text: "A", dictionaryEntry: ["X"], sourceLang: langOne, targetLang: langTwo)
    lazy var word2 = Word(text: "B", dictionaryEntry: ["Y"], sourceLang: langOne, targetLang: langTwo)
    lazy var word3 = Word(text: "C", dictionaryEntry: ["Q", "X"], sourceLang: langOne, targetLang: langTwo)

    func arrangeSearch() {
        let createWordDbWorker = CreateWordDbWorkerImpl()

        _ = try! createWordDbWorker.create(word: word1).toBlocking().first()
        _ = try! createWordDbWorker.create(word: word2).toBlocking().first()
        _ = try! createWordDbWorker.create(word: word3).toBlocking().first()
    }

    override func tearDownWithError() throws {
        _ = try deleteAllWords().toBlocking().first()
    }

    func test_wordListFetcher__wordList__empty() throws {
        // Arrange:
        let wordListFetcher = WordListFetcherImpl()

        // Act:
        let wordList = try! wordListFetcher.wordList()

        // Assert:
        XCTAssertEqual(0, wordList.count)
    }

    func test_createWord__createSingleWordInDB() throws {
        // Arrange:
        let createWordDbWorker = CreateWordDbWorkerImpl()
        let wordListFetcher = WordListFetcherImpl()
        let word = Word(text: "word", sourceLang: langOne, targetLang: langTwo)

        // Act:
        _ = try createWordDbWorker.create(word: word)
            .toBlocking().first()

        // Assert:
        XCTAssertEqual(try! wordListFetcher.wordList()[0], word)
    }

    func test_updateWord__updateSecondWordInAListOfThreeWords() throws {
        // Arrange:
        let createWordDbWorker = CreateWordDbWorkerImpl()
        let updateWordDbWorker = UpdateWordDbWorkerImpl()
        let wordListFetcher = WordListFetcherImpl()

        let wordOne = Word(text: "one", sourceLang: langOne, targetLang: langTwo, createdAt: 0)
        let wordTwo = Word(text: "two", sourceLang: langOne, targetLang: langTwo, createdAt: 1)
        let wordThree = Word(text: "three", sourceLang: langOne, targetLang: langTwo, createdAt: 2)
        var updatedWordTwo = wordTwo

        updatedWordTwo.isFavorite = true
        updatedWordTwo.dictionaryEntry = ["translation"]

        // Act:
        _ = try createWordDbWorker.create(word: wordOne).toBlocking().first()
        _ = try createWordDbWorker.create(word: wordTwo).toBlocking().first()
        _ = try createWordDbWorker.create(word: wordThree).toBlocking().first()
        _ = try updateWordDbWorker.update(word: updatedWordTwo).toBlocking().first()

        // Assert:
        let words = try! wordListFetcher.wordList()

        XCTAssertEqual(words, [wordThree, updatedWordTwo, wordOne])
    }

    func test_search_searchBySourceWord_shouldFindSecondWord() throws {
        // Arrange:
        arrangeSearch()

        // Act:
        let words = SearchableWordListImpl().findWords(contain: "B")

        // Assert:
        XCTAssertEqual(words, [word2])
    }

    func test_search_searchNonExistingWord_returnsEmptyResult() throws {
        // Arrange:
        arrangeSearch()

        // Act:
        let words = SearchableWordListImpl().findWords(contain: "D")

        // Assert:
        XCTAssertEqual(words.count, 0)
    }

    func test_search__findWordsWhereTranslationContains__returnsTwoWords() throws {
        // Arrange:
        arrangeSearch()

        // Act:
        let words = SearchableWordListImpl().findWords(whereTranslationContains: "X")

        // Assert:
        XCTAssertEqual(words, [word1, word3])
    }
}
