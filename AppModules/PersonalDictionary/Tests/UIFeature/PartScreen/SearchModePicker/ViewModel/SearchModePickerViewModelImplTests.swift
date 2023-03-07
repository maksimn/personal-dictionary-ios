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
        let searchModeStreamMock = MutableSearchModeStreamMock()
        let viewModel = SearchModePickerViewModelImpl(searchModeStream: searchModeStreamMock, logger: LoggerMock())

        searchModeStreamMock.methodMock = { _ in counter += 1 }

        // Act
        viewModel.searchMode.accept(.byTranslation)

        // Assert
        XCTAssertEqual(counter, 1)
    }
}
