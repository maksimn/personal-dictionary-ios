//
//  WordItem.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import Foundation

struct WordItem {

    typealias Id = Tagged<WordItem, String>

    let id: Id
    let text: String
    let translation: String?
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

    func update(translation: String) -> WordItem {
        WordItem(id: id,
                 text: text,
                 translation: translation,
                 sourceLang: sourceLang,
                 targetLang: targetLang,
                 createdAt: createdAt)
    }
}
