//
//  WordItem.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import CoreModule
import Foundation

/// Данные о слове в словаре.
struct Word: Equatable, Hashable, CustomStringConvertible {

    typealias Id = Tagged<Word, String>

    /// Идентификатор слова
    let id: Id

    /// Написание слова на исходном языке
    let text: String

    /// Перевод слова на целевой язык
    var translation: String?

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
        translation: String? = nil,
        sourceLang: Lang,
        targetLang: Lang,
        isFavorite: Bool = false,
        createdAt: Int = Int(Date().timeIntervalSince1970)
    ) {
        self.id = id
        self.text = text
        self.translation = translation
        self.sourceLang = sourceLang
        self.targetLang = targetLang
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }

    /// Операция сравнения на равенство объектов данного типа.
    static func == (lhs: Word, rhs: Word) -> Bool {
        lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.translation == rhs.translation &&
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
        (id: \(id.raw), \
        text: \(text),
        translation: \(translation ?? ""), \
        sourceLang: \(sourceLang.id.raw), \
        targetLang: \(targetLang.id.raw), \
        isFavorite: \(isFavorite) \
        createdAt: \(createdAt))
        """
    }
}
