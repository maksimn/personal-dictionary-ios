//
//  DictionaryEntryViewModelImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 22.08.2023.
//

import XCTest
@testable import PersonalDictionary

class DictionaryEntryViewModelImplTests: XCTestCase {

    var viewModel: DictionaryEntryViewModelImpl!
    var modelMock: DictionaryEntryModelMock!

    let langOne = Lang(id: .init(raw: 1), name: "Aa", shortName: "a")
    lazy var word = Word(text: "word", sourceLang: langOne, targetLang: langOne)
    lazy var wordWithEntry = Word(text: "word", dictionaryEntry: ["x", "y"], sourceLang: langOne, targetLang: langOne)

    func arrange() {
        modelMock = .init()
        viewModel = .init(model: modelMock)
        modelMock.getDictionaryEntryMock = { .just($0) }
    }

    func test_load_success_wordWithDictionaryEntryLoaded() {
        arrange()
        modelMock.loadMock = { self.wordWithEntry }

        // Act
        viewModel.load()

        // Assert
        XCTAssertEqual(viewModel.state.value, DictionaryEntryState.loaded(wordWithEntry))
    }

    func test_load_error_errorStateIfNoDictionaryEntryForTheWord() {
        arrange()
        modelMock.loadMock = { self.word }

        // Act
        viewModel.load()

        // Assert
        XCTAssertEqual(
            viewModel.state.value,
            DictionaryEntryState.error(DictionaryEntryError.emptyDictionaryEntry(word).withError())
        )
    }

    func test_load_error_generalModelLoadError() {
        arrange()
        modelMock.loadMock = { throw ErrorMock.err }

        // Act
        viewModel.load()

        // Assert
        XCTAssertEqual(viewModel.state.value, DictionaryEntryState.error(ErrorMock.err.withError()))
    }

    func test_retryDictionaryEntryRequest_success_dictionaryEntryFetched() {
        arrange()
        viewModel.state.accept(.error(DictionaryEntryError.emptyDictionaryEntry(word).withError()))
        modelMock.getDictionaryEntryMock = { _ in .just(self.wordWithEntry) }

        // Act
        viewModel.retryDictionaryEntryRequest()

        // Assert
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for x seconds")], timeout: 0.001)

        XCTAssertEqual(viewModel.state.value, DictionaryEntryState.loaded(wordWithEntry))
    }

    func test_retryDictionaryEntryRequest_transitionThroughLoadingState() {
        arrange()
        viewModel.state.accept(.error(DictionaryEntryError.emptyDictionaryEntry(word).withError()))

        // Act
        viewModel.retryDictionaryEntryRequest()

        // Assert
        XCTAssertEqual(viewModel.state.value, DictionaryEntryState.loading)
    }

    func test_retryDictionaryEntryRequest_noopIfWordLoaded() {
        var counter = 0

        arrange()
        viewModel.state.accept(.loaded(wordWithEntry))
        modelMock.getDictionaryEntryMock = {
            counter += 1
            return .just($0)
        }

        // Act
        viewModel.retryDictionaryEntryRequest()

        // Assert
        XCTAssertEqual(counter, 0)
    }

    func test_retryDictionaryEntryRequest_generalGetDictionaryEntryError() {
        let errorState = DictionaryEntryState.error(DictionaryEntryError.emptyDictionaryEntry(word).withError())

        arrange()
        viewModel.state.accept(errorState)
        modelMock.getDictionaryEntryMock = { _ in .error(ErrorMock.err) }

        // Act
        viewModel.retryDictionaryEntryRequest()

        // Assert
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for x seconds")], timeout: 0.001)

        XCTAssertEqual(viewModel.state.value, errorState)
    }
}
