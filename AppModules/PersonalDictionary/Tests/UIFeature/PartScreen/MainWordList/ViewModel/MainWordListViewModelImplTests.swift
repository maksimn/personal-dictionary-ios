//
//  FavoriteWordListViewModelImplTests.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 27.02.2023.
//

import RxSwift
import XCTest
@testable import PersonalDictionary

final class MainWordListViewModelImplTests: XCTestCase {

    func test_fetch_empty() throws {
        // Arrange
        let mockFetcher = MockWordListFetcher(returnValue: [])
        let viewModel = MainWordListViewModelImpl(wordListFetcher: mockFetcher)

        // Act
        viewModel.fetch()

        // Assert
        XCTAssertEqual(viewModel.wordList.value.count, 0)
    }

    func test_fetch_fetchedDataInViewModel() throws {
        // Arrange
        let lang = Lang(id: .init(raw: 0), name: "", shortName: "")
        let wordList = [
            Word(text: "a", sourceLang: lang, targetLang: lang),
            Word(text: "b", sourceLang: lang, targetLang: lang)
        ]
        let mockFetcher = MockWordListFetcher(returnValue: wordList)
        let viewModel = MainWordListViewModelImpl(wordListFetcher: mockFetcher)

        // Act
        viewModel.fetch()

        // Assert
        XCTAssertEqual(viewModel.wordList.value, wordList)
    }
}
