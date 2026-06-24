//
//  DictionaryEntryModelImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 22.08.2023.
//

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
        dictionaryServiceMock.fetchDictionaryEntryMock = { _ in self.wordData }
    }

    func arrangeRealm(entryData: Data = Data()) {
        runAsyncTaskBlocking {
            _ = try await RealmCreateWordDbWorker().create(word: self.word)
            _ = try await RealmDictionaryEntryDbInserter().insert(entry: entryData, for: self.word)
        }
    }

    override func tearDownWithError() throws {
        removeRealmData()
    }

    // - MARK: Tests

    func test_load_success_whenTheWordAndItsEntryExistInRealm() async throws {
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

    func test_load_error_whenDictionaryEntryIsEmpty() async throws {
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

    func test_getDictionaryEntry_success_serviceRequestSuccess() async throws {
        arrange()

        // Act
        let resultVO = try await model.getDictionaryEntry(for: word)

        // Assert
        XCTAssertEqual(resultVO, dictionaryEntryVO)
    }

    func test_getDictionaryEntry_success_notifyAboutTheWordUpdate() async throws {
        arrange()

        var counter = 0

        updatedWordSenderMock.sendUpdatedWordMock = { _ in counter += 1 }

        // Act
        _ = try await model.getDictionaryEntry(for: word)

        // Assert
        XCTAssertEqual(counter, 1)
    }

    func test_getDictionaryEntry_error_whenServiceRequestFailed() async throws {
        arrange()
        dictionaryServiceMock.fetchDictionaryEntryMock = { _ in throw ErrorMock.err }

        // Act
        do {
            _ = try await model.getDictionaryEntry(for: word)

            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? ErrorMock, ErrorMock.err)
        }
    }
}
