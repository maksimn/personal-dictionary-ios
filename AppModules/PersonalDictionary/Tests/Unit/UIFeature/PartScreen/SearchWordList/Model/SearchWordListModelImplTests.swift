//
//  SearchWordListModelImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 03.03.2023.
//

import XCTest
@testable import PersonalDictionary

final class SearchWordListModelImplTests: XCTestCase {

    var model: SearchWordListModelImpl!

    var searchableWordListMock: SearchableWordListMock!
    var translationSearchableWordListMock: TranslationSearchableWordListMock!

    let lang = Lang.defaultValueFUT

    func arrange() {
        searchableWordListMock = SearchableWordListMock()
        translationSearchableWordListMock = TranslationSearchableWordListMock()
        model = SearchWordListModelImpl(
            searchableWordList: searchableWordListMock,
            translationSearchableWordList: translationSearchableWordListMock
        )
    }

    func test_performSearch_searchBySourceWord_returnsCorrectData() throws {
        // Arrange
        arrange()

        let words = [
            Word(text: "A", sourceLang: lang, targetLang: lang),
            Word(text: "BA", sourceLang: lang, targetLang: lang)
        ]

        searchableWordListMock.findWordsMock = { _ in words }

        // Act
        let searchResultData = model.performSearch(for: "A", mode: .bySourceWord)

        // Assert
        XCTAssertEqual(searchResultData, SearchResultData(searchState: .fulfilled, foundWordList: words))
    }

    func test_performSearch_searchByTranslation_returnsCorrectData() throws {
        // Arrange
        arrange()

        let words = [Word(text: "Aa", translation: "Bb", sourceLang: lang, targetLang: lang)]

        translationSearchableWordListMock.findWordsWhereTranslationContainsMock = { _ in words }

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
        arrange()
        searchableWordListMock.findWordsMock = { _ in [] }

        // Act
        let searchResultData = model.performSearch(for: searchText, mode: mode)

        // Assert
        XCTAssertEqual(searchResultData, SearchResultData(searchState: .initial, foundWordList: []))
    }
}
