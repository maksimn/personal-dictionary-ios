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
        var notificationcounter = 0
        let searchTextSenderMock = SearchTextSenderMock()
        let model = SearchTextInputModelImpl(searchTextSender: searchTextSenderMock, logger: LoggerMock())

        searchTextSenderMock.methodMock = { _ in notificationcounter += 1 }

        // Act
        model.process("abc")

        // Assert
        XCTAssertEqual(notificationcounter, 1)
    }
}
