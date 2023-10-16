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

    let langOne = Lang(id: .init(raw: 1), nameKey: .init(raw: "Aa"), shortNameKey: .init(raw: "a"))
    let langTwo = Lang(id: .init(raw: 2), nameKey: .init(raw: "Bb"), shortNameKey: .init(raw: "b"))

    lazy var word1 = Word(text: "A", translation: "X", sourceLang: langOne, targetLang: langTwo, createdAt: 3)
    lazy var word2 = Word(text: "B", translation: "Y", sourceLang: langOne, targetLang: langTwo, createdAt: 2)
    lazy var word3 = Word(text: "C", translation: "Q", sourceLang: langOne, targetLang: langTwo, createdAt: 1)

    func arrangeSearch() {
        let createWordDbWorker = RealmCreateWordDbWorker()

        _ = try! createWordDbWorker.create(word: word1).toBlocking().first()
        _ = try! createWordDbWorker.create(word: word2).toBlocking().first()
        _ = try! createWordDbWorker.create(word: word3).toBlocking().first()
    }

    override func tearDownWithError() throws {
        _ = try deleteAll(WordDAO.self).toBlocking().first()
        _ = try deleteAll(DictionaryEntryDAO.self).toBlocking().first()
    }

    func test_wordListFetcher__wordList__empty() throws {
        // Arrange:
        let wordListFetcher = RealmWordListFetcher()

        // Act:
        let wordList = try! wordListFetcher.wordList()

        // Assert:
        XCTAssertEqual(0, wordList.count)
    }

    func test_createWord__createSingleWordInDB() throws {
        // Arrange:
        let createWordDbWorker = RealmCreateWordDbWorker()
        let wordListFetcher = RealmWordListFetcher()
        let word = Word(text: "word", sourceLang: langOne, targetLang: langTwo)

        // Act:
        _ = try createWordDbWorker.create(word: word)
            .toBlocking().first()

        // Assert:
        XCTAssertEqual(try! wordListFetcher.wordList()[0], word)
    }

    func test_updateWord__updateSecondWordInAListOfThreeWords() throws {
        // Arrange:
        let createWordDbWorker = RealmCreateWordDbWorker()
        let updateWordDbWorker = RealmUpdateWordDbWorker()
        let wordListFetcher = RealmWordListFetcher()

        let wordOne = Word(text: "one", sourceLang: langOne, targetLang: langTwo, createdAt: 0)
        let wordTwo = Word(text: "two", sourceLang: langOne, targetLang: langTwo, createdAt: 1)
        let wordThree = Word(text: "three", sourceLang: langOne, targetLang: langTwo, createdAt: 2)
        var updatedWordTwo = wordTwo

        updatedWordTwo.isFavorite = true
        updatedWordTwo.translation = "translation"

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
        let words = RealmSearchableWordList().findWords(contain: "B")

        // Assert:
        XCTAssertEqual(words, [word2])
    }

    func test_search_searchNonExistingWord_returnsEmptyResult() throws {
        // Arrange:
        arrangeSearch()

        // Act:
        let words = RealmSearchableWordList().findWords(contain: "D")

        // Assert:
        XCTAssertEqual(words.count, 0)
    }

    // swiftlint:disable function_body_length
    func test_findWordsWhereTranslationContains__returnsTwoWords() throws {
        // Arrange:
        arrangeSearch()

        let ponsArray1 = [
            PonsResponseData(
                hits: [
                    PonsResponseDataHit(
                        roms: [
                            PonsResponseDataHitsRom(
                                headword: "A",
                                wordclass: "",
                                arabs: [
                                    PonsResponseDataHitsRomsArab(
                                        header: "",
                                        translations: [
                                            PonsResponseDataHitsRomsArabsTranslation(
                                                target: "X",
                                                source: ""
                                            )
                                        ]
                                    )
                                ]
                            )
                        ]
                    )
                ]
            )
        ]
        let data1 = try! JSONEncoder().encode(ponsArray1)

        let ponsArray2 = [
            PonsResponseData(
                hits: [
                    PonsResponseDataHit(
                        roms: [
                            PonsResponseDataHitsRom(
                                headword: "B",
                                wordclass: "",
                                arabs: [
                                    PonsResponseDataHitsRomsArab(
                                        header: "",
                                        translations: [
                                            PonsResponseDataHitsRomsArabsTranslation(
                                                target: "Y",
                                                source: ""
                                            )
                                        ]
                                    )
                                ]
                            )
                        ]
                    )
                ]
            )
        ]
        let data2 = try! JSONEncoder().encode(ponsArray2)

        let ponsArray3 = [
            PonsResponseData(
                hits: [
                    PonsResponseDataHit(
                        roms: [
                            PonsResponseDataHitsRom(
                                headword: "C",
                                wordclass: "",
                                arabs: [
                                    PonsResponseDataHitsRomsArab(
                                        header: "",
                                        translations: [
                                            PonsResponseDataHitsRomsArabsTranslation(
                                                target: "Q",
                                                source: ""
                                            ),
                                            PonsResponseDataHitsRomsArabsTranslation(
                                                target: "X",
                                                source: ""
                                            )
                                        ]
                                    )
                                ]
                            )
                        ]
                    )
                ]
            )
        ]
        let data3 = try! JSONEncoder().encode(ponsArray3)

        let dictionaryEntryDbInserter = RealmDictionaryEntryDbInserter()

        _ = try! dictionaryEntryDbInserter.insert(entry: data1, for: word1).toBlocking().first()
        _ = try! dictionaryEntryDbInserter.insert(entry: data2, for: word2).toBlocking().first()
        _ = try! dictionaryEntryDbInserter.insert(entry: data3, for: word3).toBlocking().first()

        // Act:
        let words = RealmTranslationSearchableWordList().findWords(whereTranslationContains: "X")

        // Assert:
        XCTAssertEqual(words, [word1, word3])
    }
}
