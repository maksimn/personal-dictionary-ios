//
//  RealmWordListFetcherTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import XCTest
@testable import PersonalDictionary

class RealmWordListFetcherTests: XCTestCase {

    func test_wordListFetcher__wordList__empty() throws {
        // Arrange:
        let wordListFetcher = RealmWordListFetcher()

        // Act:
        let wordList = try! wordListFetcher.wordList()

        // Assert:
        XCTAssertEqual(0, wordList.count)
    }
}
