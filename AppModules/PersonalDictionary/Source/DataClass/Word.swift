//
//  WordItem.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import CoreModule
import Foundation

/// Word data in the dictionary.
struct Word: Equatable, Hashable, CustomStringConvertible {

    typealias Id = Tagged<Word, String>

    /// Word identifier
    let id: Id

    /// Word spelling in the source language
    let text: String

    /// Translation
    var translation: String = "" {
        didSet {
            setUpdatedAtProp()
        }
    }

    /// Source language
    let sourceLang: Lang

    /// Target language
    let targetLang: Lang

    /// Whether the word is marked as favorite
    var isFavorite: Bool {
        didSet {
            setUpdatedAtProp()
        }
    }

    /// Object creation date and time as an integer
    let createdAt: Int

    /// Object update date and time as an integer
    var updatedAt: Int

    static var updatedAtPropSetter: () -> Int = { Date().integer }

    init(
        id: Id = Id(raw: UUID().uuidString),
        text: String,
        translation: String = "",
        sourceLang: Lang,
        targetLang: Lang,
        isFavorite: Bool = false,
        createdAt: Int = Date().integer
    ) {
        self.id = id
        self.text = text
        self.translation = translation
        self.sourceLang = sourceLang
        self.targetLang = targetLang
        self.isFavorite = isFavorite
        self.createdAt = createdAt
        self.updatedAt = createdAt
    }

    /// Equality operator
    static func == (lhs: Word, rhs: Word) -> Bool {
        lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.translation == rhs.translation &&
        lhs.sourceLang == rhs.sourceLang &&
        lhs.targetLang == rhs.targetLang &&
        lhs.isFavorite == rhs.isFavorite
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id.raw)
    }

    var description: String {
        """
        Word(id: \(id.raw), \
        text: \(text), \
        translation: \(translation), \
        sourceLang: \(sourceLang.description), \
        targetLang: \(targetLang.description), \
        isFavorite: \(isFavorite), \
        createdAt: \(createdAt)), \
        updatedAt: \(updatedAt)
        """
    }

    private mutating func setUpdatedAtProp() {
        updatedAt = Self.updatedAtPropSetter()
    }
}

struct WordData: Equatable {
    let word: Word
    let entry: Data
}

/// A bucket with data on a word update operation.
struct UpdatedWord: Equatable {

    /// Current (updated) value of a word object.
    let newValue: Word

    /// Previous (old) value of the word object.
    let oldValue: Word
}
