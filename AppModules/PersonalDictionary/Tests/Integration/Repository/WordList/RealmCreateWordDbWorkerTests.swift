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
        removeRealmData()
    }

    func test_createWord__createSingleWordInDB() async throws {
        // Arrange:
        let createWordDbWorker = RealmCreateWordDbWorker()

        // Act:
        _ = try await createWordDbWorker.create(word: Word.defaultValueFUT)

        // Assert:
        let wordListFetcher = RealmWordListFetcher()

        XCTAssertEqual(try! wordListFetcher.wordList()[0], Word.defaultValueFUT)
    }
}
