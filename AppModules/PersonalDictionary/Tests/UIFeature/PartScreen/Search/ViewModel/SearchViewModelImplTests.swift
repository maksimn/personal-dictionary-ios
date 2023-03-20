//
//  SearchWordListViewModelImplTests.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 03.03.2023.
//

import XCTest
@testable import PersonalDictionary

final class SearchViewModelImplTests: XCTestCase {

    func test_onSearchInputData_updateViewModelWithDataFromSearchModel() throws {
        // Arrange
        let lang = Lang(id: .init(raw: 1), name: "A", shortName: "a")
        let initialData = SearchResultData(searchState: .initial, foundWordList: [])
        let searchWordListModelMock = SearchModelMock()
        let viewModel = SearchViewModelImpl(
            initialData: initialData,
            model: searchWordListModelMock,
            searchTextStream: SearchTextStreamMock(),
            searchModeStream: SearchModeStreamMock()
        )
        let words = [
            Word(text: "A", sourceLang: lang, targetLang: lang),
            Word(text: "BA", sourceLang: lang, targetLang: lang)
        ]
        let searchResultMock = SearchResultData(searchState: .fulfilled, foundWordList: words)

        searchWordListModelMock.methodMock = { (_, _) in searchResultMock }

        // Act
        viewModel.onSearchInputData("a", .bySourceWord)

        // Assert
        XCTAssertEqual(viewModel.searchResult.value, searchResultMock)
    }
}
