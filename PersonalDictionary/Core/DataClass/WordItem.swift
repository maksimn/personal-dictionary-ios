//
//  WordItem.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import Foundation

struct WordItem {

    typealias Identifier = Tagged<WordItem, String>

    let id: Identifier
    let text: String
    let sourceLang: Lang
    let targetLang: Lang
    let createdAt: Int

    init(id: Identifier = Identifier(rawValue: UUID().uuidString),
         text: String,
         sourceLang: Lang,
         targetLang: Lang,
         createdAt: Int = Int(Date().timeIntervalSince1970)) {
        self.id = id
        self.text = text
        self.sourceLang = sourceLang
        self.targetLang = targetLang
        self.createdAt = createdAt
    }
}
