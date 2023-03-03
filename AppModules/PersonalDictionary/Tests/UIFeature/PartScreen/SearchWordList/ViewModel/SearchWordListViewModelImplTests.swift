//
//  SearchWordListViewModelImplTests.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 03.03.2023.
//

import XCTest
@testable import PersonalDictionary

final class SearchWordListViewModelImplTests: XCTestCase {

    func test_onSearchInputData_updateViewModelWithDataFromSearchModel() throws {
        // Arrange
        let lang = Lang(id: .init(raw: 1), name: "A", shortName: "a")
        let initialData = SearchResultData(searchState: .initial, foundWordList: [])
        let mockSearchWordListModel = MockSearchWordListModel()
        let viewModel = SearchWordListViewModelImpl(
            initialData: initialData,
            model: mockSearchWordListModel,
            searchTextStream: MockSearchTextStream(),
            searchModeStream: MockSearchModeStream()
        )
        let words = [
            Word(text: "A", sourceLang: lang, targetLang: lang),
            Word(text: "BA", sourceLang: lang, targetLang: lang)
        ]
        let mockSearchResult = SearchResultData(searchState: .fulfilled, foundWordList: words)

        mockSearchWordListModel.mockSearchResult = mockSearchResult

        // Act
        viewModel.onSearchInputData("a", .bySourceWord)

        // Assert
        XCTAssertEqual(viewModel.searchResult.value, mockSearchResult)
    }
}
