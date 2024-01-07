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

    let word = Word.defaultValueFUT
    lazy var dictionaryEntryVO = DictionaryEntryVO(
        word: word,
        entry: [
            DictionaryEntryItem(
                title: word.text,
                subtitle: .init("", bundle: Bundle.module),
                subitems: [DictionaryEntrySubitem(translation: "x", example: nil),
                           DictionaryEntrySubitem(translation: "y", example: nil)]
            )
        ]
    )

    func arrange() {
        modelMock = .init()
        viewModel = .init(model: modelMock)
        modelMock.getDictionaryEntryMock = { _ in .just(self.dictionaryEntryVO) }
    }

    func test_load_success_wordWithDictionaryEntryLoaded() {
        arrange()
        modelMock.loadMock = { self.dictionaryEntryVO }

        // Act
        viewModel.load()

        // Assert
        XCTAssertEqual(viewModel.state.value, DictionaryEntryState.loaded(dictionaryEntryVO))
    }

    func test_load_error_errorStateIfNoDictionaryEntryForTheWord() {
        arrange()
        modelMock.loadMock = { throw DictionaryEntryError.emptyDictionaryEntry(self.word) }

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

        // Act
        viewModel.retryDictionaryEntryRequest()

        // Assert
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for x seconds")], timeout: 0.001)

        XCTAssertEqual(viewModel.state.value, DictionaryEntryState.loaded(dictionaryEntryVO))
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
        viewModel.state.accept(.loaded(dictionaryEntryVO))
        modelMock.getDictionaryEntryMock = { _ in
            counter += 1
            return .just(self.dictionaryEntryVO)
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
