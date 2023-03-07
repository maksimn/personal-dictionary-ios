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
        let modelMock = WordListModelMock()
        let viewModel = WordListViewModelImpl(model: modelMock, wordStream: ReadableWordStreamMock())

        // Act
        viewModel.remove(at: -2)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, [])
    }

    func test_removeAtPosition_noopWhenIndexOutOfBounds_positiveIndex() throws {
        // Arrange
        let modelMock = WordListModelMock()
        let viewModel = WordListViewModelImpl(model: modelMock, wordStream: ReadableWordStreamMock())
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
        let modelMock = WordListModelMock()
        let viewModel = WordListViewModelImpl(model: modelMock, wordStream: ReadableWordStreamMock())
        let array = [
            Word(text: "a", sourceLang: lang, targetLang: lang),
            Word(text: "b", sourceLang: lang, targetLang: lang),
            Word(text: "c", sourceLang: lang, targetLang: lang)
        ]

        viewModel.wordList.accept(array)
        modelMock.removeWordMock = { _ in Single.just(array[1]) }

        // Act
        viewModel.remove(at: 1)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, [array[0], array[2]])
    }

    func test_toggleWordIsFavorite_worksCorrectly() throws {
        // Arrange
        let modelMock = WordListModelMock()
        let viewModel = WordListViewModelImpl(model: modelMock, wordStream: ReadableWordStreamMock())
        let words = [
            Word(text: "a", sourceLang: lang, targetLang: lang),
            Word(text: "b", sourceLang: lang, targetLang: lang),
            Word(text: "c", sourceLang: lang, targetLang: lang)
        ]
        var word = words[1]

        word.isFavorite.toggle()

        viewModel.wordList.accept(words)
        modelMock.updateWordMock = { word in Single.just(word) }

        // Act
        viewModel.toggleWordIsFavorite(at: 1)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, [words[0], word, words[2]])
    }

    func test_toggleWordIsFavorite_noopWhenIndexOutOfBounds() throws {
        // Arrange
        let modelMock = WordListModelMock()
        let viewModel = WordListViewModelImpl(model: modelMock, wordStream: ReadableWordStreamMock())
        let words = [
            Word(text: "a", sourceLang: lang, targetLang: lang),
            Word(text: "b", sourceLang: lang, targetLang: lang),
            Word(text: "c", sourceLang: lang, targetLang: lang)
        ]

        viewModel.wordList.accept(words)
        modelMock.updateWordMock = { word in Single.just(word) }

        // Act
        viewModel.toggleWordIsFavorite(at: 5)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, words)
    }

    func test_fetchTranslationsIfNeededWithin_success() throws {
        // Arrange
        let modelMock = WordListModelMock()
        let viewModel = WordListViewModelImpl(model: modelMock, wordStream: ReadableWordStreamMock())
        let word1 = Word(text: "a", sourceLang: lang, targetLang: lang)
        let word2 = Word(text: "b", translation: "y", sourceLang: lang, targetLang: lang)
        let word3 = Word(text: "c", sourceLang: lang, targetLang: lang)
        var translatedWord1 = word1
        var translatedWord3 = word3

        translatedWord1.translation = "x"
        translatedWord3.translation = "z"

        modelMock.fetchTranslationsForWordListMock = { (_, _, _) in Observable.from([translatedWord1, translatedWord3]) }
        viewModel.wordList.accept([word1, word2, word3])

        // Act
        _ = try viewModel.fetchTranslationsIfNeededWithin(start: 0, end: 3).toBlocking().toArray()

        // Assert
        XCTAssertEqual(viewModel.wordList.value, [translatedWord1, word2, translatedWord3])
    }

    func test_fetchTranslationsIfNeededWithin_failsWhenModelCallFails() throws {
        // Arrange
        let modelMock = WordListModelMock()
        let viewModel = WordListViewModelImpl(model: modelMock, wordStream: ReadableWordStreamMock())
        let word1 = Word(text: "a", sourceLang: lang, targetLang: lang)
        let word2 = Word(text: "b", translation: "y", sourceLang: lang, targetLang: lang)
        let word3 = Word(text: "c", sourceLang: lang, targetLang: lang)

        modelMock.fetchTranslationsForWordListMock = { (_, _, _) in .error(ErrorMock.err) }
        viewModel.wordList.accept([word1, word2, word3])

        // Act
        let observable = viewModel.fetchTranslationsIfNeededWithin(start: 0, end: 3)

        // Assert
        XCTAssertThrowsError(try observable.toBlocking().toArray())
    }
}
