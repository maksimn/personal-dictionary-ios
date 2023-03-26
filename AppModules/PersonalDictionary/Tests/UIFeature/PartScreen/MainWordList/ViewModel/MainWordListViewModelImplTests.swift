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
        let modelMock = MainWordListModelMock()
        let viewModel = MainWordListViewModelImpl(
            model: modelMock,
            newWordStream: NewWordStreamMock(),
            logger: LoggerMock()
        )

        modelMock.fetchMainWordListMock = { [] }

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
        let modelMock = MainWordListModelMock()
        let viewModel = MainWordListViewModelImpl(
            model: modelMock,
            newWordStream: NewWordStreamMock(),
            logger: LoggerMock()
        )

        modelMock.fetchMainWordListMock = { wordList }

        // Act
        viewModel.fetch()

        // Assert
        XCTAssertEqual(viewModel.wordList.value, wordList)
    }
}
