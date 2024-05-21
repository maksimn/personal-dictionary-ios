//
//  FavoriteWordListViewModelImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 27.02.2023.
//

import XCTest
@testable import PersonalDictionary

final class FavoriteWordListViewModelImplTests: XCTestCase {

    private var viewModel: FavoriteWordListViewModelImpl!
    private var fetcherMock: FavoriteWordListFetcherMock!

    func arrange() {
        fetcherMock = FavoriteWordListFetcherMock()
        viewModel = FavoriteWordListViewModelImpl(fetcher: fetcherMock)
        fetcherMock.favoriteWordListMock = { [] }
    }

    func test_fetchFavoriteWordList_empty() throws {
        // Arrange
        arrange()

        // Act
        viewModel.fetchFavoriteWordList()

        // Assert
        XCTAssertEqual(viewModel.favoriteWordList.value.count, 0)
    }

    func test_fetchFavoriteWordList_fetchedDataInViewModel() throws {
        // Arrange
        arrange()

        let lang = Lang.defaultValueFUT
        let favorites = [
            Word(text: "a", sourceLang: lang, targetLang: lang, isFavorite: true),
            Word(text: "b", sourceLang: lang, targetLang: lang, isFavorite: true)
        ]

        fetcherMock.favoriteWordListMock = { favorites }

        // Act
        viewModel.fetchFavoriteWordList()

        // Assert
        XCTAssertEqual(viewModel.favoriteWordList.value, favorites)
    }
}
