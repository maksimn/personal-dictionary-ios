//
//  RealmSearchableWordListTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import XCTest
@testable import PersonalDictionary

class RealmSearchableWordListTests: XCTestCase {

    let lang = Lang.defaultValueFUT

    lazy var word1 = Word(text: "A", translation: "X", sourceLang: lang, targetLang: lang, createdAt: 3)
    lazy var word2 = Word(text: "B", translation: "Y", sourceLang: lang, targetLang: lang, createdAt: 2)
    lazy var word3 = Word(text: "C", translation: "Q", sourceLang: lang, targetLang: lang, createdAt: 1)

    func arrangeSearch() {
        let createWordDbWorker = RealmCreateWordDbWorker()

        _ = try! createWordDbWorker.create(word: word1).toBlocking().first()
        _ = try! createWordDbWorker.create(word: word2).toBlocking().first()
        _ = try! createWordDbWorker.create(word: word3).toBlocking().first()
    }

    override func tearDownWithError() throws {
        try removeRealmData()
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
}
