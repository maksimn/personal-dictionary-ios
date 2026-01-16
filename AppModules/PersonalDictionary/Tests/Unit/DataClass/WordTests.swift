//
//  WordTests.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 17.01.2026.
//

import XCTest
@testable import PersonalDictionary

final class WordTests: XCTestCase {

    func arrange(createdAt: Int) -> Word {
        let lang = Lang.defaultValueFUT
        let word = Word(text: "a", sourceLang: lang, targetLang: lang, createdAt: createdAt)

        return word
    }

    func test_initWord_createdAtAndUpdatedAtPropsAreEqual() throws {
        let createdAt = 5
        let word = arrange(createdAt: createdAt)

        XCTAssertEqual(word.createdAt, createdAt)
        XCTAssertEqual(word.updatedAt, createdAt)
    }

    func test_updateIsFavoriteProp_updatedAtPropChanges() throws {
        var word = arrange(createdAt: 5)
        let updatedAt = 7

        Word.updatedAtPropSetter = { updatedAt }

        // Act
        word.isFavorite.toggle()

        XCTAssertEqual(word.updatedAt, updatedAt)
    }

    func test_updateTranslationProp_updatedAtPropChanges() throws {
        var word = arrange(createdAt: 5)
        let updatedAt = 8

        Word.updatedAtPropSetter = { updatedAt }

        // Act
        word.translation = "abc"

        XCTAssertEqual(word.updatedAt, updatedAt)
    }
}
