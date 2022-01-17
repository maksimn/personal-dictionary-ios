//
//  SearchEngineImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maxim Ivanov on 26.11.2021.
//

import Cuckoo
import RxBlocking
import XCTest
@testable import PersonalDictionary

final class SearchEngineImplTests: XCTestCase {

    private let lang = Lang(id: Lang.Id(raw: 1), name: "", shortName: "")
    private lazy var word1 = WordItem(text: "A", translation: "X", sourceLang: lang, targetLang: lang)
    private lazy var word2 = WordItem(text: "B", translation: "Y", sourceLang: lang, targetLang: lang)
    private lazy var word3 = WordItem(text: "C", translation: "X", sourceLang: lang, targetLang: lang)

    private var searchEngine: SearchEngineImpl?

    override func setUpWithError() throws {
        let mockWordListFetcher = MockWordListFetcher()

        stub(mockWordListFetcher) { stub in
            when(stub.wordList.get).thenReturn([word1, word2, word3])
        }

        searchEngine = SearchEngineImpl(wordListFetcher: mockWordListFetcher)
    }

    func test_findWords_searchBySourceWord_shouldFindSecondWord() throws {
        // Arrange:

        // Act:
        let single = searchEngine?.findWords(contain: "B", mode: .bySourceWord)

        // Assert:
        let result = try single?.toBlocking().first()
        XCTAssertEqual(result?.foundWordList, [word2])
        XCTAssertEqual(result?.searchState, .fulfilled)
    }

    func test_findWords_searchNonExistingWord_returnsEmptyResult() throws {
        // Arrange:

        // Act:
        let single = searchEngine?.findWords(contain: "D", mode: .bySourceWord)

        // Assert:
        let result = try single?.toBlocking().first()
        XCTAssertEqual(result?.foundWordList, [])
        XCTAssertEqual(result?.searchState, .fulfilled)
    }

    func test_findWords_emptyStringParam_returnsEmptyResultWithInitialSearchState() throws {
        // Arrange:

        // Act:
        let single = searchEngine?.findWords(contain: "", mode: .bySourceWord)

        // Assert:
        let result = try single?.toBlocking().first()
        XCTAssertEqual(result?.foundWordList, [])
        XCTAssertEqual(result?.searchState, .initial)
    }

    func test_findWords_searchByTranslation_returnsTwoWords() throws {
        // Arrange:

        // Act:
        let single = searchEngine?.findWords(contain: "X", mode: .byTranslation)

        // Assert:
        let result = try single?.toBlocking().first()
        XCTAssertEqual(result?.foundWordList, [word1, word3])
        XCTAssertEqual(result?.searchState, .fulfilled)
    }
}
