//
//  SearchTextInputViewModelImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 03.03.2023.
//

import XCTest
@testable import PersonalDictionary

final class SearchTextInputViewModelImplTests: XCTestCase {

    func test_searchText_sendsSearchTextToStream() throws {
        // Arrange
        var counter = 0
        let searchTextStreamMock = MutableSearchTextStreamMock()
        let viewModel = SearchTextInputViewModelImpl(searchTextStream: searchTextStreamMock, logger: LoggerMock())

        searchTextStreamMock.methodMock = { _ in counter += 1 }

        // Act
        viewModel.searchText.accept("abc")

        // Assert
        XCTAssertEqual(counter, 1)
    }
}
