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
        let viewModel = WordListViewModelImpl(model: modelMock, wordStream: UpdatedRemovedWordStreamMock(),
                                              logger: LoggerMock())

        // Act
        viewModel.remove(at: -2)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, [])
    }

    func test_removeAtPosition_noopWhenIndexOutOfBounds_positiveIndex() throws {
        // Arrange
        let modelMock = WordListModelMock()
        let viewModel = WordListViewModelImpl(model: modelMock, wordStream: UpdatedRemovedWordStreamMock(),
                                              logger: LoggerMock())
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
        let viewModel = WordListViewModelImpl(model: modelMock, wordStream: UpdatedRemovedWordStreamMock(),
                                              logger: LoggerMock())
        let array = [
            Word(text: "a", sourceLang: lang, targetLang: lang),
            Word(text: "b", sourceLang: lang, targetLang: lang),
            Word(text: "c", sourceLang: lang, targetLang: lang)
        ]

        viewModel.wordList.accept(array)
        modelMock.removeMock = { (_, _) in [array[0], array[2]] }
        modelMock.removeEffectMock = { (_, state) in Single.just(state) }

        // Act
        viewModel.remove(at: 1)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, [array[0], array[2]])
    }

    func test_toggleWordIsFavorite_worksCorrectly() throws {
        // Arrange
        let modelMock = WordListModelMock()
        let viewModel = WordListViewModelImpl(model: modelMock, wordStream: UpdatedRemovedWordStreamMock(),
                                              logger: LoggerMock())
        let words = [
            Word(text: "a", sourceLang: lang, targetLang: lang),
            Word(text: "b", sourceLang: lang, targetLang: lang),
            Word(text: "c", sourceLang: lang, targetLang: lang)
        ]
        var word = words[1]

        word.isFavorite.toggle()

        viewModel.wordList.accept(words)
        modelMock.updateMock = { (_, _, _) in [words[0], word, words[2]] }
        modelMock.updateEffectMock = { (_, state) in Single.just(state) }

        // Act
        viewModel.toggleWordIsFavorite(at: 1)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, [words[0], word, words[2]])
    }

    func test_toggleWordIsFavorite_noopWhenIndexOutOfBounds() throws {
        // Arrange
        let modelMock = WordListModelMock()
        let viewModel = WordListViewModelImpl(model: modelMock, wordStream: UpdatedRemovedWordStreamMock(),
                                              logger: LoggerMock())
        let words = [
            Word(text: "a", sourceLang: lang, targetLang: lang),
            Word(text: "b", sourceLang: lang, targetLang: lang),
            Word(text: "c", sourceLang: lang, targetLang: lang)
        ]

        viewModel.wordList.accept(words)

        // Act
        viewModel.toggleWordIsFavorite(at: 5)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, words)
    }

    func test_fetchTranslationsIfNeeded_success() throws {
        // Arrange
        let modelMock = WordListModelMock()
        let viewModel = WordListViewModelImpl(model: modelMock, wordStream: UpdatedRemovedWordStreamMock(),
                                              logger: LoggerMock())
        let word1 = Word(text: "a", sourceLang: lang, targetLang: lang)
        let word2 = Word(text: "b", translation: "y", sourceLang: lang, targetLang: lang)
        let word3 = Word(text: "c", sourceLang: lang, targetLang: lang)
        var translatedWord1 = word1
        var translatedWord3 = word3

        translatedWord1.translation = "x"
        translatedWord3.translation = "z"

        modelMock.fetchTranslationsForMock = { (_, _, _) in Single.just([translatedWord1, word2, translatedWord3]) }
        viewModel.wordList.accept([word1, word2, word3])

        // Act
        _ = try viewModel.fetchTranslationsIfNeeded(start: 0, end: 3).toBlocking().toArray()

        // Assert
        XCTAssertEqual(viewModel.wordList.value, [translatedWord1, word2, translatedWord3])
    }

    func test_fetchTranslationsIfNeeded_failsWhenModelCallFails() throws {
        // Arrange
        let modelMock = WordListModelMock()
        let viewModel = WordListViewModelImpl(model: modelMock, wordStream: UpdatedRemovedWordStreamMock(),
                                              logger: LoggerMock())
        let word1 = Word(text: "a", sourceLang: lang, targetLang: lang)
        let word2 = Word(text: "b", translation: "y", sourceLang: lang, targetLang: lang)
        let word3 = Word(text: "c", sourceLang: lang, targetLang: lang)

        modelMock.fetchTranslationsForMock = { (_, _, _) in .error(ErrorMock.err) }
        viewModel.wordList.accept([word1, word2, word3])

        // Act
        let observable = viewModel.fetchTranslationsIfNeeded(start: 0, end: 3)

        // Assert
        XCTAssertThrowsError(try observable.toBlocking().toArray())
    }
}
