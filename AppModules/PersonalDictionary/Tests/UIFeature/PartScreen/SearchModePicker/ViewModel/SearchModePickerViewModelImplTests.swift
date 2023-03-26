//
//  SearchModePickerViewModelImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 03.03.2023.
//

import XCTest
@testable import PersonalDictionary

final class SearchModePickerViewModelImplTests: XCTestCase {

    func test_searchMode_sendsSearchModeToStream() throws {
        // Arrange
        var counter = 0
        let searchModeSenderMock = SearchModeSenderMock()
        let viewModel = SearchModePickerViewModelImpl(searchModeSender: searchModeSenderMock, logger: LoggerMock())

        searchModeSenderMock.methodMock = { _ in counter += 1 }

        // Act
        viewModel.searchMode.accept(.byTranslation)

        // Assert
        XCTAssertEqual(counter, 1)
    }
}
