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

    func arrangeSearch() async throws {
        let createWordDbWorker = RealmCreateWordDbWorker()

        _ = try await createWordDbWorker.create(word: word1)
        _ = try await createWordDbWorker.create(word: word2)
        _ = try await createWordDbWorker.create(word: word3)
    }

    override func tearDownWithError() throws {
        removeRealmData()
    }

    func test_search_searchBySourceWord_shouldFindSecondWord() async throws {
        // Arrange:
        try await arrangeSearch()

        // Act:
        let words = RealmSearchableWordList().findWords(contain: "B")

        // Assert:
        XCTAssertEqual(words, [word2])
    }

    func test_search_searchNonExistingWord_returnsEmptyResult() async throws {
        // Arrange:
        try await arrangeSearch()

        // Act:
        let words = RealmSearchableWordList().findWords(contain: "D")

        // Assert:
        XCTAssertEqual(words.count, 0)
    }
}
