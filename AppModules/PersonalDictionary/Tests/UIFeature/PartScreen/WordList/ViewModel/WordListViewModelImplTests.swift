//
//  WordListViewModelImplTests.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 05.03.2023.
//

import XCTest
@testable import PersonalDictionary

final class WordListViewModelImplTests: XCTestCase {

    let lang = Lang(id: .init(raw: 1), name: "A", shortName: "a")

    func test_removeAtPosition_noopWhenIndexOutOfBounds_negativeIndex() throws {
        // Arrange
        let mockModel = MockWordListModel()
        let viewModel = WordListViewModelImpl(model: mockModel, wordStream: MockReadableWordStream())

        // Act
        viewModel.remove(at: -2)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, [])
    }

    func test_removeAtPosition_noopWhenIndexOutOfBounds_positiveIndex() throws {
        // Arrange
        let mockModel = MockWordListModel()
        let viewModel = WordListViewModelImpl(model: mockModel, wordStream: MockReadableWordStream())
        let array = [
            Word(text: "a", sourceLang: lang, targetLang: lang),
            Word(text: "b", sourceLang: lang, targetLang: lang)
        ]

        viewModel.wordList.accept(array)

        // Act
        viewModel.remove(at: 3)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, array)
    }

    func test_removeAtPosition_positionInsideArrayBounds_worksCorrectly() throws {
        // Arrange
        let mockModel = MockWordListModel()
        let viewModel = WordListViewModelImpl(model: mockModel, wordStream: MockReadableWordStream())
        let array = [
            Word(text: "a", sourceLang: lang, targetLang: lang),
            Word(text: "b", sourceLang: lang, targetLang: lang),
            Word(text: "c", sourceLang: lang, targetLang: lang)
        ]

        viewModel.wordList.accept(array)

        // Act
        viewModel.remove(at: 1)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, [array[0], array[2]])
    }
}
