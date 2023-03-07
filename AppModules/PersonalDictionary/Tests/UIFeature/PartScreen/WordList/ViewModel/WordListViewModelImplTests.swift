//
//  WordListViewModelImplTests.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 05.03.2023.
//

import RxSwift
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
        mockModel.mockRemoveResult = Single.just(array[1])

        // Act
        viewModel.remove(at: 1)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, [array[0], array[2]])
    }

    func test_toggleWordIsFavorite_worksCorrectly() throws {
        // Arrange
        let mockModel = MockWordListModel()
        let viewModel = WordListViewModelImpl(model: mockModel, wordStream: MockReadableWordStream())
        let array = [
            Word(text: "a", sourceLang: lang, targetLang: lang),
            Word(text: "b", sourceLang: lang, targetLang: lang),
            Word(text: "c", sourceLang: lang, targetLang: lang)
        ]
        var word = array[1]

        word.isFavorite.toggle()

        viewModel.wordList.accept(array)
        mockModel.mockUpdateResult = Single.just(word)

        // Act
        viewModel.toggleWordIsFavorite(at: 1)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, [array[0], word, array[2]])
    }

    func test_fetchTranslationsIfNeededWithin() throws {
        // Arrange
        let mockModel = MockWordListModel()
        let viewModel = WordListViewModelImpl(model: mockModel, wordStream: MockReadableWordStream())
        let word1 = Word(text: "a", sourceLang: lang, targetLang: lang)
        let word2 = Word(text: "b", translation: "y", sourceLang: lang, targetLang: lang)
        let word3 = Word(text: "c", sourceLang: lang, targetLang: lang)
        var translatedWord1 = word1
        var translatedWord3 = word3

        translatedWord1.translation = "x"
        translatedWord3.translation = "z"

        mockModel.mockFetchTranslationsFor = { Observable.from([translatedWord1, translatedWord3]) }
        viewModel.wordList.accept([word1, word2, word3])

        // Act
        viewModel.fetchTranslationsIfNeededWithin(start: 0, end: 3)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, [translatedWord1, word2, translatedWord3])
    }
}
