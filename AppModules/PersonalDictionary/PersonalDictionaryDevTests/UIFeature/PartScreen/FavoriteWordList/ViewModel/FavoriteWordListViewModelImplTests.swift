//
//  FavoriteWordListViewModelImplTests.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 27.02.2023.
//

import RxSwift
import XCTest
@testable import PersonalDictionary

final class FavoriteWordListViewModelImplTests: XCTestCase {

    func test_fetchFavoriteWordList_empty() throws {
        // Arrange
        let viewModel = FavoriteWordListViewModelImpl(
            fetcher: MockFavoriteWordListFetcher(returnValue: []),
            wordStream: MockReadableWordStream()
        )

        // Act
        viewModel.fetchFavoriteWordList()

        // Assert
        XCTAssertEqual(viewModel.favoriteWordList.value.count, 0)
    }

    func test_fetchFavoriteWordList_fetchedDataInViewModel() throws {
        // Arrange
        let lang = Lang(id: .init(raw: 0), name: "", shortName: "")
        let favorites = [
            Word(text: "a", sourceLang: lang, targetLang: lang, isFavorite: true),
            Word(text: "b", sourceLang: lang, targetLang: lang, isFavorite: true)
        ]
        let viewModel = FavoriteWordListViewModelImpl(
            fetcher: MockFavoriteWordListFetcher(returnValue: favorites),
            wordStream: MockReadableWordStream()
        )

        // Act
        viewModel.fetchFavoriteWordList()

        // Assert
        XCTAssertEqual(viewModel.favoriteWordList.value, favorites)
    }
}
