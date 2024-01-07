//
//  RealmCreateWordDbWorkerTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import XCTest
@testable import PersonalDictionary

class RealmCreateWordDbWorkerTests: XCTestCase {

    override func tearDownWithError() throws {
        try removeRealmData()
    }

    func test_createWord__createSingleWordInDB() throws {
        // Arrange:
        let createWordDbWorker = RealmCreateWordDbWorker()

        // Act:
        _ = try createWordDbWorker.create(word: Word.defaultValueFUT).toBlocking().first()

        // Assert:
        let wordListFetcher = RealmWordListFetcher()

        XCTAssertEqual(try! wordListFetcher.wordList()[0], Word.defaultValueFUT)
    }
}
