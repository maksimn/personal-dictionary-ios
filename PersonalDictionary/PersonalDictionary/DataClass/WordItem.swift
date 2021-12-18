//
//  WordItem.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import CoreModule
import Foundation

struct WordItem: Equatable {

    typealias Id = Tagged<WordItem, String>

    let id: Id
    let text: String
    var translation: String?
    let sourceLang: Lang
    let targetLang: Lang
    let createdAt: Int

    init(id: Id = Id(raw: UUID().uuidString),
         text: String,
         translation: String? = nil,
         sourceLang: Lang,
         targetLang: Lang,
         createdAt: Int = Int(Date().timeIntervalSince1970)) {
        self.id = id
        self.text = text
        self.translation = translation
        self.sourceLang = sourceLang
        self.targetLang = targetLang
        self.createdAt = createdAt
    }

    static func == (lhs: WordItem, rhs: WordItem) -> Bool {
        return lhs.id == rhs.id &&
            lhs.text == rhs.text &&
            lhs.translation == rhs.translation &&
            lhs.sourceLang.id == rhs.sourceLang.id &&
            lhs.targetLang.id == rhs.targetLang.id &&
            lhs.createdAt == rhs.createdAt
    }
}
