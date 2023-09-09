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
    var decoderMock: DictionaryEntryDecoderMock!
    var updatedWordSenderMock: UpdatedWordSenderMock!

    // Test data set:
    let langOne = Lang(id: .init(raw: 1), name: "Aa", shortName: "a")
    lazy var word = Word(text: "word", sourceLang: langOne, targetLang: langOne)
    lazy var wordData = WordData(word: word, entry: Data())
    lazy var dictionaryEntryVO = DictionaryEntryVO(word: word, entry: ["x", "y"])

    func arrange() {
        dictionaryServiceMock = DictionaryServiceMock()
        decoderMock = DictionaryEntryDecoderMock()
        updatedWordSenderMock = UpdatedWordSenderMock()
        model = DictionaryEntryModelImpl(
            id: word.id,
            dictionaryService: dictionaryServiceMock,
            decoder: decoderMock,
            updatedWordSender: updatedWordSenderMock
        )
    }

    func arrangeGetDictionaryEntry() {
        arrange()
        dictionaryServiceMock.fetchDictionaryEntryMock = { _ in Single.just(self.wordData) }
        decoderMock.decodeMock = { (_, _) in self.dictionaryEntryVO.entry }
    }

    override func tearDownWithError() throws {
        _ = try deleteAll(WordDAO.self).toBlocking().first()
        _ = try deleteAll(DictionaryEntryDAO.self).toBlocking().first()
    }

    func test_load_success_whenTheWordExistsInRealm() throws {
        arrange()

        _ = try! CreateWordDbWorkerImpl().create(word: word).toBlocking().first()
        _ = try! DictionaryEntryDbWorkerImpl().insert(entry: Data(), for: word).toBlocking().first()

        // Act
        let loadedVO = try model.load()

        // Assert
        XCTAssertEqual(loadedVO, DictionaryEntryVO(word: word, entry: []))
    }

    func test_load_error_whenTheWordDoesntExistsInRealm() throws {
        arrange()

        // Act and assert
        XCTAssertThrowsError(try model.load())
    }

    func test_getDictionaryEntry_success_serviceRequestSuccess() throws {
        arrangeGetDictionaryEntry()

        // Act
        let resultVO = try! model.getDictionaryEntry(for: word).toBlocking().first()

        // Assert
        XCTAssertEqual(resultVO, dictionaryEntryVO)
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
