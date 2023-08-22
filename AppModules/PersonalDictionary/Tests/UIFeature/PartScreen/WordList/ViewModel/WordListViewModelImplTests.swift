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

    var viewModel: WordListViewModelImpl<WordListRouterMock>!
    var modelMock: WordListModelMock!
    var wordStreamMock: UpdatedRemovedWordStreamMock!
    var routerMock: WordListRouterMock!

    let lang = Lang(id: .init(raw: 1), name: "A", shortName: "a")
    lazy var words = [
        Word(text: "a", sourceLang: lang, targetLang: lang),
        Word(text: "b", sourceLang: lang, targetLang: lang),
        Word(text: "c", sourceLang: lang, targetLang: lang)
    ]

    func arrange() {
        modelMock = WordListModelMock()
        wordStreamMock = UpdatedRemovedWordStreamMock()
        routerMock = WordListRouterMock()
        viewModel = WordListViewModelImpl(
            model: modelMock,
            wordStream: wordStreamMock,
            router: routerMock,
            logger: LoggerMock()
        )
    }

    func test_select_noRoutingWhenIndexOutOfRange() throws {
        // Arrange
        var routerCallCounter = 0

        arrange()
        viewModel.wordList.accept(words)
        routerMock.navigateMock = { _ in routerCallCounter += 1 }

        // Act
        viewModel.select(at: 5)

        // Assert
        XCTAssertEqual(routerCallCounter, 0)
    }

    func test_select_navigateWhenIndexIsCorrect() throws {
        // Arrange
        var routerCallCounter = 0

        arrange()
        viewModel.wordList.accept(words)
        routerMock.navigateMock = { _ in routerCallCounter += 1 }

        // Act
        viewModel.select(at: 2)

        // Assert
        XCTAssertEqual(routerCallCounter, 1)
    }

    func test_removeAtPosition_noopWhenIndexOutOfBounds_negativeIndex() throws {
        // Arrange
        arrange()
        viewModel.wordList.accept(words)

        // Act
        viewModel.remove(at: -2)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, words)
    }

    func test_removeAtPosition_noopWhenIndexOutOfBounds_positiveIndex() throws {
        // Arrange
        arrange()
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
        arrange()

        viewModel.wordList.accept(words)
        modelMock.removeMock = { (_, _) in [self.words[0], self.words[2]] }
        modelMock.removeEffectMock = { (_, state) in Single.just(state) }

        // Act
        viewModel.remove(at: 1)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, [words[0], words[2]])
    }

    func test_toggleWordIsFavorite_worksCorrectly() throws {
        // Arrange
        arrange()

        var word = words[1]

        word.isFavorite.toggle()
        viewModel.wordList.accept(words)
        modelMock.updateMock = { (_, _, _) in [self.words[0], word, self.words[2]] }
        modelMock.updateEffectMock = { (_, state) in Single.just(state) }

        // Act
        viewModel.toggleWordIsFavorite(at: 1)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, [words[0], word, words[2]])
    }

    func test_toggleWordIsFavorite_noopWhenIndexOutOfBounds() throws {
        // Arrange
        arrange()
        viewModel.wordList.accept(words)

        // Act
        viewModel.toggleWordIsFavorite(at: 5)

        // Assert
        XCTAssertEqual(viewModel.wordList.value, words)
    }
}
