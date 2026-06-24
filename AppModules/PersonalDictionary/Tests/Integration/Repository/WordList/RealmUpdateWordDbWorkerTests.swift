//
//  RealmUpdateWordDbWorkerTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import XCTest
@testable import PersonalDictionary

class RealmUpdateWordDbWorkerTests: XCTestCase {

    override func tearDownWithError() throws {
        removeRealmData()
    }

    func test_updateWord__updateSecondWordInAListOfThreeWords() async throws {
        // Arrange:
        let createWordDbWorker = RealmCreateWordDbWorker()
        let updateWordDbWorker = RealmUpdateWordDbWorker()
        let wordListFetcher = RealmWordListFetcher()
        let lang = Lang.defaultValueFUT

        let word1 = Word(text: "one", sourceLang: lang, targetLang: lang, createdAt: 0)
        let word2 = Word(text: "two", sourceLang: lang, targetLang: lang, createdAt: 1)
        let word3 = Word(text: "three", sourceLang: lang, targetLang: lang, createdAt: 2)
        var updatedWord2 = word2

        updatedWord2.isFavorite = true
        updatedWord2.translation = "translation"

        _ = try await createWordDbWorker.create(word: word1)
        _ = try await createWordDbWorker.create(word: word2)
        _ = try await createWordDbWorker.create(word: word3)

        // Act:
        _ = try await updateWordDbWorker.update(word: updatedWord2)

        // Assert:
        let words = try! wordListFetcher.wordList()

        XCTAssertEqual(words, [word3, updatedWord2, word1])
    }
}
