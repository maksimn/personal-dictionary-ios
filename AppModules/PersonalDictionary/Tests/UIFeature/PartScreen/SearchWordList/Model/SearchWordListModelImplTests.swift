//
//  SearchWordListModelImplTests.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 03.03.2023.
//

import XCTest
@testable import PersonalDictionary

final class SearchWordListModelImplTests: XCTestCase {

    let lang = Lang(id: .init(raw: 1), name: "A", shortName: "a")

    func test_performSearch_searchBySourceWord_returnsCorrectData() throws {
        // Arrange
        let mockSearchableWordList = MockSearchableWordList()
        let model = SearchWordListModelImpl(searchableWordList: mockSearchableWordList)
        let words = [
            Word(text: "A", sourceLang: lang, targetLang: lang),
            Word(text: "BA", sourceLang: lang, targetLang: lang)
        ]

        mockSearchableWordList.mockFindWordsResult = words

        // Act
        let searchResultData = model.performSearch(for: "A", mode: .bySourceWord)

        // Assert
        XCTAssertEqual(searchResultData, SearchResultData(searchState: .fulfilled, foundWordList: words))
    }

    func test_performSearch_searchByTranslation_returnsCorrectData() throws {
        // Arrange
        let mockSearchableWordList = MockSearchableWordList()
        let model = SearchWordListModelImpl(searchableWordList: mockSearchableWordList)
        let words = [Word(text: "Aa", translation: "Bb", sourceLang: lang, targetLang: lang)]

        mockSearchableWordList.mockFindWordsWhereTranslationContainsResult = words

        // Act
        let searchResultData = model.performSearch(for: "b", mode: .byTranslation)

        // Assert
        XCTAssertEqual(searchResultData, SearchResultData(searchState: .fulfilled, foundWordList: words))
    }

    func test_performSearch_emptyTextBySourceWord_returnsInitialSearchResultData() throws {
        try performSearch_returnsInitialSearchResultData_for(searchText: "", mode: .bySourceWord)
    }

    func test_performSearch_emptyTextByTranslation_returnsInitialSearchResultData() throws {
        try performSearch_returnsInitialSearchResultData_for(searchText: "", mode: .byTranslation)
    }

    func test_performSearch_whitespacesText_returnsInitialSearchResultData() throws {
        try performSearch_returnsInitialSearchResultData_for(searchText: "   ", mode: .bySourceWord)
    }

    func test_performSearch_whitespacesAndNewlines_returnsInitialSearchResultData() throws {
        try performSearch_returnsInitialSearchResultData_for(searchText: "   \n\n", mode: .bySourceWord)
    }

    func performSearch_returnsInitialSearchResultData_for(searchText: String, mode: SearchMode) throws {
        // Arrange
        let mockSearchableWordList = MockSearchableWordList()
        let model = SearchWordListModelImpl(searchableWordList: mockSearchableWordList)

        mockSearchableWordList.mockFindWordsResult = []

        // Act
        let searchResultData = model.performSearch(for: searchText, mode: mode)

        // Assert
        XCTAssertEqual(searchResultData, SearchResultData(searchState: .initial, foundWordList: []))
    }
}
