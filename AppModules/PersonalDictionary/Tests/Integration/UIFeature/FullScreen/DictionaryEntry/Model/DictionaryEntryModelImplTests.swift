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

    // - MARK: Mocks

    var dictionaryServiceMock: DictionaryServiceMock!
    var decoderMock: DictionaryEntryDecoderMock!
    var updatedWordSenderMock: UpdatedWordSenderMock!

    // - MARK: Test Data Set

    lazy var word = Word(text: "word", sourceLang: Lang.defaultValueFUT, targetLang: Lang.defaultValueFUT)
    lazy var dataString = """
[
  {
    "hits": [
      {
        "roms": [
          {
            "headword": "\(word.text)",
            "headword_full": "",
            "wordclass": "",
            "arabs": [
              {
                "header": "",
                "translations": [
                  {
                    "source": "",
                    "target": "x"
                  },
                  {
                    "source": "",
                    "target": "y"
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }
]
"""
    lazy var wordData = WordData(word: word, entry: Data(dataString.utf8))
    lazy var dictionaryEntryVO = DictionaryEntryVO(
        word: word,
        entry: (try? PonsDictionaryEntryDecoder().decode(Data(dataString.utf8))) ?? []
    )

    // - MARK: Arrange methods

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
        decoderMock.decodeMock = { _ in self.dictionaryEntryVO.entry }
        dictionaryServiceMock.fetchDictionaryEntryMock = { _ in Single.just(self.wordData) }
    }

    func arrangeRealm(entryData: Data = Data()) {
        _ = try! RealmCreateWordDbWorker().create(word: word).toBlocking().first()
        _ = try! RealmDictionaryEntryDbInserter().insert(entry: entryData, for: word).toBlocking().first()
    }

    override func tearDownWithError() throws {
        try removeRealmData()
    }

    // - MARK: Tests

    func test_load_success_whenTheWordAndItsEntryExistInRealm() throws {
        // Arrange
        arrange()
        arrangeRealm(entryData: Data(dataString.utf8))

        // Act
        let loadedVO = try model.load()

        // Assert
        XCTAssertEqual(loadedVO, dictionaryEntryVO)
    }

    func test_load_error_whenTheWordDoesntExistsInRealm() throws {
        arrange()

        // Act and assert
        XCTAssertThrowsError(try model.load())
    }

    func test_load_error_whenDictionaryEntryIsEmpty() throws {
        arrange()
        arrangeRealm()
        decoderMock.decodeMock = { _ in [] }

        do {
            // Act
            _ = try model.load()
        } catch {
            XCTAssertEqual(
                error.withError(),
                DictionaryEntryError.emptyDictionaryEntry(word).withError()
            )
        }
    }

    func test_getDictionaryEntry_success_serviceRequestSuccess() throws {
        arrange()

        // Act
        let resultVO = try! model.getDictionaryEntry(for: word).toBlocking().first()

        // Assert
        XCTAssertEqual(resultVO, dictionaryEntryVO)
    }

    func test_getDictionaryEntry_success_notifyAboutTheWordUpdate() throws {
        arrange()

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
