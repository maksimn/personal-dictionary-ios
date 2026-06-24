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
        modelMock.getDictionaryEntryMock = { _ in self.dictionaryEntryVO }
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

    func test_retryDictionaryEntryRequest_success_dictionaryEntryFetched() async {
        arrange()
        viewModel.state.send(.error(DictionaryEntryError.emptyDictionaryEntry(word).withError()))

        // Act
        viewModel.retryDictionaryEntryRequest()

        try? await Task.sleep(nanoseconds: 10_000_000)

        // Assert
        XCTAssertEqual(viewModel.state.value, DictionaryEntryState.loaded(dictionaryEntryVO))
    }

    func test_retryDictionaryEntryRequest_transitionThroughLoadingState() {
        arrange()
        viewModel.state.send(.error(DictionaryEntryError.emptyDictionaryEntry(word).withError()))

        // Act
        viewModel.retryDictionaryEntryRequest()

        // Assert
        XCTAssertEqual(viewModel.state.value, DictionaryEntryState.loading)
    }

    func test_retryDictionaryEntryRequest_noopIfWordLoaded() {
        var counter = 0

        arrange()
        viewModel.state.send(.loaded(dictionaryEntryVO))
        modelMock.getDictionaryEntryMock = { _ in
            counter += 1
            return self.dictionaryEntryVO
        }

        // Act
        viewModel.retryDictionaryEntryRequest()

        // Assert
        XCTAssertEqual(counter, 0)
    }

    func test_retryDictionaryEntryRequest_generalGetDictionaryEntryError() async {
        let errorState = DictionaryEntryState.error(DictionaryEntryError.emptyDictionaryEntry(word).withError())

        arrange()
        viewModel.state.send(errorState)
        modelMock.getDictionaryEntryMock = { _ in throw ErrorMock.err }

        // Act
        viewModel.retryDictionaryEntryRequest()

        try? await Task.sleep(nanoseconds: 10_000_000)

        // Assert
        XCTAssertEqual(viewModel.state.value, errorState)
    }
}
