//
//  MainWordListModelImplTests.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.03.2023.
//

import RxSwift
import XCTest
@testable import PersonalDictionary

final class MainWordListModelImplTests: XCTestCase {

    let lang = Lang(id: .init(raw: 1), name: "A", shortName: "a")
    lazy var word = Word(text: "abc", sourceLang: lang, targetLang: lang)
    lazy var word1 = Word(text: "a", sourceLang: lang, targetLang: lang)
    lazy var word2 = Word(text: "b", translation: "y", sourceLang: lang, targetLang: lang)
    lazy var word3 = Word(text: "c", sourceLang: lang, targetLang: lang)
    lazy var wordList = [word1, word2, word3]

    func test_createWord_returnsCorrectWordListState() throws {
        // Arrange
        let model = MainWordListModelImpl(
            wordListRepository: WordListRepositoryMock(),
            translationService: TranslationServiceMock()
        )

        // Act
        let newWordList = model.create(word, state: wordList)

        // Assert
        XCTAssertEqual(newWordList, [word, word1, word2, word3])
    }

    func test_createEffect_worksCorrectlyForHappyPath() throws {
        // Arrange
        var dbUpdateCounter = 0
        let wordListRepositoryMock = WordListRepositoryMock()
        let translationServiceMock = TranslationServiceMock()
        let model = MainWordListModelImpl(
            wordListRepository: wordListRepositoryMock,
            translationService: translationServiceMock
        )
        let translatedWord = Word(text: "abc", translation: "translation", sourceLang: lang, targetLang: lang)

        wordListRepositoryMock.addWordMock = { word in Single.just(word) }
        wordListRepositoryMock.updateWordMock = { (word: Word) in
            dbUpdateCounter += 1
            return Single.just(word)
        }
        translationServiceMock.methodMock = { _ in Single.just(translatedWord) }

        // Act
        let nextState = try model.createEffect(word, state: [word, word1, word2, word3]).toBlocking().first()

        // Assert
        XCTAssertEqual(dbUpdateCounter, 1)
        XCTAssertEqual(nextState, [translatedWord, word1, word2, word3])
    }

    func test_createEffect_failsWhenDbCreateWordFails() throws {
        // Arrange
        let wordListRepositoryMock = WordListRepositoryMock()
        let model = MainWordListModelImpl(
            wordListRepository: wordListRepositoryMock,
            translationService: TranslationServiceMock()
        )

        wordListRepositoryMock.addWordMock = { word in Single.error(ErrorMock.err) }

        // Act
        let single = model.createEffect(word, state: wordList)

        // Assert
        XCTAssertThrowsError(try single.toBlocking().first())
    }
}
