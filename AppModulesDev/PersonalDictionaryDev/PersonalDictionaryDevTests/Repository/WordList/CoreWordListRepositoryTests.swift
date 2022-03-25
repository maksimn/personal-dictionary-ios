//
//  LangRepositoryImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maxim Ivanov on 04.10.2021.
//

import Cuckoo
import XCTest
@testable import PersonalDictionary

class CoreWordListRepositoryTests: XCTestCase {

    var wordListRepository: CoreWordListRepository!

    let langOne = Lang(id: Lang.Id(raw: 1), name: "Aa", shortName: "a")
    let langTwo = Lang(id: Lang.Id(raw: 2), name: "Bb", shortName: "b")

    override func setUpWithError() throws {
        let mockLangRepository = MockLangRepository()

        stub(mockLangRepository) { stub in
            when(stub.allLangs.get)
                .thenReturn([langOne, langTwo])
        }

        wordListRepository = CoreWordListRepository(
            args: CoreWordListRepositoryArgs(
                bundle: Bundle(for: type(of: self)),
                persistentContainerName: "TestStorageModel"
            ),
            langRepository: mockLangRepository,
            logger: LoggerStub()
        )
    }

    override func tearDownWithError() throws {
        try wordListRepository.removeAllWordItems()
    }

    func test_wordList__empty() throws {
        // Arrange:

        // Act:
        let wordList = wordListRepository.wordList

        // Assert:
        XCTAssertEqual(0, wordList.count)
    }

    func test_add__addSingleWord() throws {
        // Arrange:
        let word = WordItem(text: "word", sourceLang: langOne, targetLang: langTwo)

        // Act:
        _ = try wordListRepository.add(word)
            .toBlocking().first()

        // Assert:
        XCTAssertEqual(wordListRepository.wordList[0], word)
    }

    func test_update__updateSecondWordInAListOfThreeWords() throws {
        // Arrange:
        let wordOne = WordItem(text: "wordOne", sourceLang: langOne, targetLang: langTwo)
        let wordTwo = WordItem(text: "wordTwo", sourceLang: langOne, targetLang: langTwo)
        let wordThree = WordItem(text: "wordThree", sourceLang: langOne, targetLang: langTwo)
        var updatedWordTwo = wordTwo

        updatedWordTwo.isFavorite = true
        updatedWordTwo.translation = "translation"

        // Act:
        _ = try wordListRepository.add(wordOne).toBlocking().first()
        _ = try wordListRepository.add(wordTwo).toBlocking().first()
        _ = try wordListRepository.add(wordThree).toBlocking().first()
        _ = try wordListRepository.update(updatedWordTwo).toBlocking().first()

        // Assert:
        let word = wordListRepository.wordList.first(where: { $0.id == wordTwo.id })

        XCTAssertEqual(word, updatedWordTwo)
    }
}
