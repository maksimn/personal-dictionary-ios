//
//  WordListRepositoryImpTests.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import RxBlocking
import XCTest
@testable import PersonalDictionary

class WordListRepositoryImpTests: XCTestCase {

    var wordListRepository: WordListRepositoryImpl!

    let langOne = Lang(id: Lang.Id(raw: 1), name: "Aa", shortName: "a")
    let langTwo = Lang(id: Lang.Id(raw: 2), name: "Bb", shortName: "b")

    lazy var word1 = Word(text: "A", translation: "X", sourceLang: langOne, targetLang: langTwo)
    lazy var word2 = Word(text: "B", translation: "Y", sourceLang: langOne, targetLang: langTwo)
    lazy var word3 = Word(text: "C", translation: "X", sourceLang: langOne, targetLang: langTwo)

    lazy var repositoryArgs = {
        WordListRepositoryArgs(
            bundle: Bundle(for: type(of: self)),
            persistentContainerName: "TestStorageModel"
        )
    }()

    lazy var mockLangRepository = MockLangRepository(allLangsValue: [langOne, langTwo])

    override func tearDownWithError() throws {
        try wordListRepository.removeAllWords()
    }

    func createWordListRepository() {
        wordListRepository = WordListRepositoryImpl(
            args: repositoryArgs,
            langRepository: mockLangRepository,
            logger: LoggerStub()
        )
    }

    func createSearchableWordList() {
        createWordListRepository()

        _ = try! wordListRepository.add(word1).toBlocking().first()
        _ = try! wordListRepository.add(word2).toBlocking().first()
        _ = try! wordListRepository.add(word3).toBlocking().first()
    }

    func test_wordList__empty() throws {
        // Arrange:
        createWordListRepository()

        // Act:
        let wordList = wordListRepository.wordList

        // Assert:
        XCTAssertEqual(0, wordList.count)
    }

    func test_add__addSingleWord() throws {
        // Arrange:
        createWordListRepository()
        let word = Word(text: "word", sourceLang: langOne, targetLang: langTwo)

        // Act:
        _ = try wordListRepository.add(word)
            .toBlocking().first()

        // Assert:
        XCTAssertEqual(wordListRepository.wordList[0], word)
    }

    func test_update__updateSecondWordInAListOfThreeWords() throws {
        // Arrange:
        createWordListRepository()
        let wordOne = Word(text: "wordOne", sourceLang: langOne, targetLang: langTwo)
        let wordTwo = Word(text: "wordTwo", sourceLang: langOne, targetLang: langTwo)
        let wordThree = Word(text: "wordThree", sourceLang: langOne, targetLang: langTwo)
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

    func test_findWords_searchBySourceWord_shouldFindSecondWord() throws {
        // Arrange:
        createSearchableWordList()

        // Act:
        let words = wordListRepository.findWords(contain: "B")

        // Assert:
        XCTAssertEqual(words, [word2])
    }

    func test_findWords_searchNonExistingWord_returnsEmptyResult() throws {
        // Arrange:
        createSearchableWordList()

        // Act:
        let words = wordListRepository.findWords(contain: "D")

        // Assert:
        XCTAssertEqual(words.count, 0)
    }

    func test_findWordsWhereTranslationContains_returnsTwoWords() throws {
        // Arrange:
        createSearchableWordList()

        // Act:
        let words = wordListRepository.findWords(whereTranslationContains: "X")

        // Assert:
        XCTAssertEqual(words, [word1, word3])
    }
}
