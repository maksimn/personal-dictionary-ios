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
        try removeRealmData()
    }

    func test_updateWord__updateSecondWordInAListOfThreeWords() throws {
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

        _ = try createWordDbWorker.create(word: word1).toBlocking().first()
        _ = try createWordDbWorker.create(word: word2).toBlocking().first()
        _ = try createWordDbWorker.create(word: word3).toBlocking().first()

        // Act:
        _ = try updateWordDbWorker.update(word: updatedWord2).toBlocking().first()

        // Assert:
        let words = try! wordListFetcher.wordList()

        XCTAssertEqual(words, [word3, updatedWord2, word1])
    }
}
