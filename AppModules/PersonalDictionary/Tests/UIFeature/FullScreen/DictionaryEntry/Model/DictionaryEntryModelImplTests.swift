//
//  DictionaryEntryModelImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 22.08.2023.
//

import RxSwift
import XCTest
@testable import PersonalDictionary

class DictionaryEntryModelImplTests: XCTestCase {

    var model: DictionaryEntryModelImpl!
    var dictionaryServiceMock: DictionaryServiceMock!
    var updateWordDbWorkerMock: UpdateWordDbWorkerMock!
    var updatedWordSenderMock: UpdatedWordSenderMock!

    // Test data set:
    let langOne = Lang(id: .init(raw: 1), name: "Aa", shortName: "a")
    lazy var word = Word(text: "word", sourceLang: langOne, targetLang: langOne)
    lazy var wordWithDictEntry: Word = {
        var updated = word

        updated.dictionaryEntry = ["x", "y"]

        return updated
    }()

    func arrange() {
        dictionaryServiceMock = DictionaryServiceMock()
        updateWordDbWorkerMock = UpdateWordDbWorkerMock()
        updatedWordSenderMock = UpdatedWordSenderMock()
        model = DictionaryEntryModelImpl(
            id: word.id,
            dictionaryService: dictionaryServiceMock,
            updateWordDbWorker: updateWordDbWorkerMock,
            updatedWordSender: updatedWordSenderMock
        )
    }

    func arrangeGetDictionaryEntry() {
        arrange()
        dictionaryServiceMock.fetchDictionaryEntryMock = { _ in Single.just(self.wordWithDictEntry) }
        updateWordDbWorkerMock.updateWordMock = { .just($0) }
        updatedWordSenderMock.sendUpdatedWordMock = { _ in }
    }

    override func tearDownWithError() throws {
        _ = try deleteAllWords().toBlocking().first()
    }

    func test_load_success_whenTheWordExistsInRealm() throws {
        arrange()

        _ = try! CreateWordDbWorkerImpl().create(word: word).toBlocking().first()

        // Act
        let loadedWord = try model.load()

        // Assert
        XCTAssertEqual(loadedWord, word)
    }

    func test_load_error_whenTheWordDoesntExistsInRealm() throws {
        arrange()

        // Act and assert
        XCTAssertThrowsError(try model.load())
    }

    func test_getDictionaryEntry_success_serviceRequestSuccess() throws {
        arrangeGetDictionaryEntry()

        // Act
        let resultWord = try! model.getDictionaryEntry(for: word).toBlocking().first()

        // Assert
        XCTAssertEqual(resultWord, wordWithDictEntry)
    }

    func test_getDictionaryEntry_success_updatesWordInDB() throws {
        arrangeGetDictionaryEntry()

        var counter = 0

        updateWordDbWorkerMock.updateWordMock = {
            counter += 1
            return .just($0)
        }

        // Act
        _ = try! model.getDictionaryEntry(for: word).toBlocking().first()

        // Assert
        XCTAssertEqual(counter, 1)
    }

    func test_getDictionaryEntry_success_notifyAboutTheWordUpdate() throws {
        arrangeGetDictionaryEntry()

        var counter = 0

        updatedWordSenderMock.sendUpdatedWordMock = { _ in counter += 1 }

        // Act
        _ = try! model.getDictionaryEntry(for: word).toBlocking().first()

        // Assert
        XCTAssertEqual(counter, 1)
    }

    func test_getDictionaryEntry_error_whenServiceRequestFailed() throws {
        arrange()
        dictionaryServiceMock.fetchDictionaryEntryMock = { _ in .error(ErrorMock.err) }

        // Act
        do {
            _ = try model.getDictionaryEntry(for: word).toBlocking().single()

            XCTAssertTrue(false)
        } catch {
            XCTAssertEqual(error as? ErrorMock, ErrorMock.err)
        }
    }
}
