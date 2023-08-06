//
//  WordItem.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import CoreModule
import Foundation

typealias DictionaryEntry = [String]

/// Данные о слове в словаре.
struct Word: Equatable, Hashable, CustomStringConvertible {

    typealias Id = Tagged<Word, String>

    /// Идентификатор слова
    let id: Id

    /// Написание слова на исходном языке
    let text: String

    /// Словарная статья для данного слова
    var dictionaryEntry: DictionaryEntry = []

    /// Исходный язык
    let sourceLang: Lang

    /// Целевой язык
    let targetLang: Lang

    /// Является ли слово избранным
    var isFavorite: Bool

    /// Дата и время создания объекта в целочисленном виде
    let createdAt: Int

    init(
        id: Id = Id(raw: UUID().uuidString),
        text: String,
        dictionaryEntry: DictionaryEntry = [],
        sourceLang: Lang,
        targetLang: Lang,
        isFavorite: Bool = false,
        createdAt: Int = Int(Date().timeIntervalSince1970)
    ) {
        self.id = id
        self.text = text
        self.dictionaryEntry = dictionaryEntry
        self.sourceLang = sourceLang
        self.targetLang = targetLang
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }

    /// Операция сравнения на равенство объектов данного типа.
    static func == (lhs: Word, rhs: Word) -> Bool {
        lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.dictionaryEntry == rhs.dictionaryEntry &&
        lhs.sourceLang == rhs.sourceLang &&
        lhs.targetLang == rhs.targetLang &&
        lhs.isFavorite == rhs.isFavorite &&
        lhs.createdAt == rhs.createdAt
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id.raw)
    }

    var description: String {
        """
        Word(id: \(id.raw), \
        text: \(text), \
        dictionaryEntry: \(dictionaryEntryDescription), \
        sourceLang: \(sourceLang.id.raw), \
        targetLang: \(targetLang.id.raw), \
        isFavorite: \(isFavorite), \
        createdAt: \(createdAt))
        """
    }

    private var dictionaryEntryDescription: String {
        let count = dictionaryEntry.count

        return dictionaryEntry.isEmpty ?
            "<empty>" :
            "[\(dictionaryEntry.first ?? "")\(count > 1 ? ", ...\(count - 1) values" : "")]"
    }
}

struct WordVO: Equatable, Identifiable {
    let _id: Word.Id
    let text: String
    let translation: String
    let sourceLang: String
    let targetLang: String
    var isFavorite: Bool

    init(_ word: Word) {
        _id = word.id
        text = word.text
        translation = word.dictionaryEntry.first ?? ""
        sourceLang = word.sourceLang.shortName
        targetLang = word.targetLang.shortName
        isFavorite = word.isFavorite
    }

    var id: String {
        _id.raw
    }
}
